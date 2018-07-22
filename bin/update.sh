#!/usr/bin/env bash

export AWS_ACCESS_KEY_ID="$CLOUDCUBE_ACCESS_KEY_ID"
export AWS_SECRET_ACCESS_KEY="$CLOUDCUBE_SECRET_ACCESS_KEY"
export AWS_BUCKET=$(basename "$CLOUDCUBE_URL")

aws s3 sync "s3://$AWS_BUCKET" ./private

./splatnet2statink/splatnet2statink.py -r

aws s3 sync ./private "s3://$AWS_BUCKET"
