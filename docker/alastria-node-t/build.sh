#!/bin/bash

rm -rf alastria-access-point
git clone https://github.com/alastria/alastria-access-point

rm -rf alastria-node
git clone https://github.com/alastria/alastria-node -b testnet2

rm -rf quorum
git clone https://github.com/alastria/quorum

IMAGE_NAME=digitelts/alastria-node-t:latest

#docker rm $IMAGE_NAME
#docker rm $(docker ps -a --format {{.Names}} | grep "NOMBRECONTENEDOR"

docker build -t $IMAGE_NAME \
	.

