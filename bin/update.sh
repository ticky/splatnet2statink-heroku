#!/usr/bin/env bash

export AWS_ACCESS_KEY_ID="$CLOUDCUBE_ACCESS_KEY_ID"
export AWS_SECRET_ACCESS_KEY="$CLOUDCUBE_SECRET_ACCESS_KEY"
export AWS_BUCKET="s3://cloud-cube/$(basename "$CLOUDCUBE_URL")"
export CONFIG_PATH="./config"

aws s3 sync "$AWS_BUCKET" "$CONFIG_PATH"

pushd "$CONFIG_PATH"
  splatnet2statink -r
popd

aws s3 sync "$CONFIG_PATH" "$AWS_BUCKET"
