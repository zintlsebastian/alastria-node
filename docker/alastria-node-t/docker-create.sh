#!/bin/bash

IMAGE_NAME=digitelts/alastria-node-t:latest

DIRECTORY="./config"

NODE_NAME=$(< $DIRECTORY/NODE_NAME)
NODE_TYPE=$(< $DIRECTORY/NODE_TYPE)
DATA_DIR=$(< $DIRECTORY/DATA_DIR)
ENABLE_CONSTELLATION=$(< $DIRECTORY/ENABLE_CONSTELLATION)
EXTRA_DOCKER_ARGUMENTS=${EXTRA_DOCKER_ARGUMENTS:-}

if ( [ -z "${NODE_NAME}" ] ); then
  echo "Error: File NODE_NAME empty"
  exit 0
fi

if ( [ -z "${NODE_TYPE}" ] ); then
  echo "Error: File NODE_TYPE empty"
  exit 0
fi

if ( [ -z "${DATA_DIR}" ] ); then
  echo "Error: File DATA_DIR empty"
  exit 0
fi

if ( [ -z "${ENABLE_CONSTELLATION}" ] ); then
  echo "Error: File ENABLE_CONSTELLATION empty"
  exit 0
  if ( [ "${ENABLE_CONSTELLATION}" ] == "true" ); then
      CONSTELLATION_ARGUMENTS=" -p 9000:9000"
  fi
fi

if ( [ -z "${PASSWORD}" ] ); then
  echo "Error: File PASSWORD empty"
  exit 0
fi

# alejandro.alfonso
# WIP
docker rm $NODE_NAME
# docker rm -f $(docker ps -a --format {{.Names}} | grep "NOMBRECONTENEDOR")

docker create --name ${NODE_NAME} \
      -v ${DATA_DIR}:/root/alastria \
      -p 21000:21000 -p 21000:21000/udp ${CONSTELLATION_ARGUMENTS} \
      -p 22000:22000 \
      -p 80:80 -p 443:443 \
      -e NODE_NAME=${NODE_NAME} \
      -e NODE_TYPE=${NODE_TYPE} \
      -e ENABLE_CONSTELLATION=${ENABLE_CONSTELLATION} \
      -e PASSWORD=${PASSWORD} \
     ${EXTRA_DOCKER_ARGUMENTS} ${IMAGE_NAME}
