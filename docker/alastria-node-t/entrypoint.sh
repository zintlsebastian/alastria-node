#!/bin/bash

_term() {
    pkill -f geth
    wait
}

trap _term SIGTERM

if [ ! -f ~/alastria/data/IDENTITY ]; then
    # test for a fist installation
    ./init.sh auto $NODE_TYPE $NODE_NAME
elif [ ! -f ~/alastria/data/DOCKER_VERSION_$DOCKER_VERSION ]; then
    # A revisar
    echo "[*] Updating static-nodes and permissioned-nodes"

    ./updatePerm.sh $NODE_TYPE
    rm -f ~/alastria/data/DOCKER_VERSION_* 2> /dev/null
    touch ~/alastria/data/DOCKER_VERSION_$DOCKER_VERSION
fi

#/etc/init.d/nginx stop
#/etc/init.d/nginx start
#nginx -g "daemon off;"
#ARGS="--watch --local-rpc"
#if [ ! $MONITOR_ENABLED -eq 1 ]; then
#    ARGS="--watch --local-rpc --no-monitor"
#fi
#exec ./start.sh $ARGS &

#echo "./start.sh $ARGS &"

# just for debug
sleep infinity

child=$!
wait "$child"
