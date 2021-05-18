#!/bin/bash
set -x && \
  docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 -t mowerr/ubuntu-base:latest --pull --push --build-arg UBUNTU_TAG=latest . && \
  docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 -t mowerr/ubuntu-base:20.04 --pull --push --build-arg UBUNTU_TAG=20.04 . && \
  docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 -t mowerr/ubuntu-base:18.04 --pull --push --build-arg UBUNTU_TAG=18.04 .

