#!/usr/bin/env bash

set -euo pipefail

echo "splatnet2statink for Heroku: Starting up!"
export AWS_ACCESS_KEY_ID="$CLOUDCUBE_ACCESS_KEY_ID"
export AWS_SECRET_ACCESS_KEY="$CLOUDCUBE_SECRET_ACCESS_KEY"
export AWS_BUCKET="s3://cloud-cube/$(basename "$CLOUDCUBE_URL")"
export ZIPBALL_HEAD_FILENAME="../splatnet2statink.zip.headers"
export ZIPBALL_ETAG_FILENAME="splatnet2statink.zip.etag"
export ZIPBALL_FILENAME="../splatnet2statink.zip"
export ZIPBALL_URL="https://github.com/frozenpandaman/splatnet2statink/archive/master.zip"
export CACHED_PATH="./cached"

function get_etag_from_headers() {
  sed \
    -n \
    -e '/200 OK/,$p' | \
  grep ETag | \
  cut \
    -d " " \
    -f2
}

function get_cache_tag() {
  curl \
    --head \
    --location \
    "$ZIPBALL_URL" |
  get_etag_from_headers
}

function download_latest_code() {
  echo "Downloading the latest code..."
  # Download the zipball
  curl \
    --silent \
    --location \
    --dump-header "$ZIPBALL_HEAD_FILENAME" \
    -o "$ZIPBALL_FILENAME" \
    "$ZIPBALL_URL"

  echo "Extracting code..."
  unzip \
    -u \
    "$ZIPBALL_FILENAME" \
    -d . && \
  mv \
    ./splatnet2statink-master/* \
    . && \
  rm \
    -rf \
    ./splatnet2statink-master

  echo "Updating cache information..."
  # Store the updated ETag (using the headers from the actual request)
  cat "$ZIPBALL_HEAD_FILENAME" | \
    get_etag_from_headers > "$ZIPBALL_ETAG_FILENAME"
}

echo "Fetching previous state..."
aws s3 sync "$AWS_BUCKET" "$CACHED_PATH"
echo "Got my state! Moving into the cached directory..."

pushd "$CACHED_PATH" > /dev/null
  echo "Checking for cached code..."
  if [[ ! -f "$ZIPBALL_ETAG_FILENAME" ]]; then
    echo "No cached code found!"
    download_latest_code
  else
    echo "Cached code found, checking for updates..."
    STORED_CACHE_TAG="$(<"$ZIPBALL_ETAG_FILENAME")"
    LATEST_CACHE_TAG="$(get_cache_tag)"

    # If they don't match, download_latest_code & then store cache tag from it
    if [[ "$STORED_CACHE_TAG" != "$LATEST_CACHE_TAG" ]]; then
      echo "Updates found!"
      download_latest_code
    else
      echo "No updates needed!"
    fi
  fi

  echo "Running splatnet2statink..."
  python ./splatnet2statink.py -r
  echo "Done!"
popd > /dev/null

echo "Pushing fresh state back up..."
aws s3 sync "$CACHED_PATH" "$AWS_BUCKET"
echo "Done!"
