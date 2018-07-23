#!/usr/bin/env bash

set -eu

echo "splatnet2statink for Heroku: Starting up!"
export AWS_ACCESS_KEY_ID="$CLOUDCUBE_ACCESS_KEY_ID"
export AWS_SECRET_ACCESS_KEY="$CLOUDCUBE_SECRET_ACCESS_KEY"
export AWS_BUCKET="s3://cloud-cube/$(basename "$CLOUDCUBE_URL")"
export CONFIG_PATH="./config"

echo "Fetching fresh secrets..."
aws s3 sync "$AWS_BUCKET" "$CONFIG_PATH"
echo "Got my secrets! Moving into the secrets directory..."

pushd "$CONFIG_PATH"
  echo "Running splatnet2statink..."
  splatnet2statink -r
  echo "Done!"
popd

echo "Pushing any changes to my secrets back up..."
aws s3 sync "$CONFIG_PATH" "$AWS_BUCKET"
echo "Done!"
