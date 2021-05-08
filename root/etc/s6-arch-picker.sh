#!/bin/bash

if [[ $TARGETARCH == "arm64" ]]; then
  echo "aarch64"
elif [[ $TARGETARCH == "arm" ]]; then
  echo "armhf"
else
  echo "$TARGETARCH"
fi