#!/bin/bash
set -x && docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 -t mowerr/ubuntu-base:"$1" --pull --build-arg UBUNTU_TAG="$1" .
