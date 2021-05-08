#!/bin/bash
set -x && docker buildx build --platform linux/amd64 -t mowerr/ubuntu-base:"$1" --pull --push --build-arg UBUNTU_TAG="$1" --build-arg S6_ARCH=amd64 .
set -x && docker buildx build --platform linux/arm64 -t mowerr/ubuntu-base:"$1" --pull --push --build-arg UBUNTU_TAG="$1" --build-arg S6_ARCH=aarch64 .
set -x && docker buildx build --platform linux/arm/v7 -t mowerr/ubuntu-base:"$1" --pull --push --build-arg UBUNTU_TAG="$1" --build-arg S6_ARCH=armhf .

