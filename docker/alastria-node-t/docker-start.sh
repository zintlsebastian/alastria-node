#!/bin/bash

DIRECTORY="./config"

NODE_NAME=$(<$DIRECTORY/NODE_NAME)

if ( [ -z "${NODE_NAME}" ] ); then
  echo "Error: File NODE_NAME empty"
  exit 0
fi

docker start -i ${NODE_NAME}
