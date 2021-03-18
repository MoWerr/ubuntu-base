#!/bin/bash
docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 -t mowerr/ubuntu-base:20.04 --push --pull --build-arg UBUNTU_TAG=20.04
docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 -t mowerr/ubuntu-base:18.04 --push --pull --build-arg UBUNTU_TAG=18.04 
docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 -t mowerr/ubuntu-base:latest --push --pull --build-arg UBUNTU_TAG=latest
