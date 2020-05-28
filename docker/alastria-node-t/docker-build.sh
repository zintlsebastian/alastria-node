#!/bin/bash

IMAGE_NAME=digitelts/alastria-node-t:latest

if ( [ -z "${IMAGE_NAME}" ] ); then
  echo "Error: File IMAGE_NAME empty"
  exit 0
fi

docker build -t ${IMAGE_NAME} \
	.
