#!/bin/bash

MESSAGE='Usage: start.sh <--clean> <--no-monitor> <--watch> <--local-rpc> <--logrotate>'

WATCH=0
CLEAN=0
GCMODE="full"
RPCADDR=0.0.0.0
LOGROTATE=0

IDENTITY=$(< $HOME/alastria/data/IDENTITY)
NODE_TYPE=$(< $HOME/alastria/data/NODE_TYPE)
NETID=83584648538

TIME="_$(date +%Y%m%d%H%M%S)"

# options for metrics generation to InfluxDB server
INFLUX_METRICS=" --metrics --metrics.influxdb \
--metrics.influxdb.endpoint http://geth-metrics.planisys.net:8086 --metrics.influxdb.database alastria \
--metrics.influxdb.username alastriausr --metrics.influxdb.password ala0str1AX1 --metrics.influxdb.host.tag=${IDENTITY}"

if [ "${NODE_TYPE}" == "bootnode" ]; then
   GLOBAL_ARGS="--networkid ${NETID} --identity ${IDENTITY} --permissioned --port 21000 --ethstats ${IDENTITY}:bb98a0b6442386d0cdf8a31b267892c1@netstats.telsius.alastria.io:80 --targetgaslimit 8000000 --syncmode fast --nodiscover ${INFLUX_METRICS}"
 else
   GLOBAL_ARGS="--networkid ${NETID} --identity ${IDENTITY} --permissioned --rpc --rpcaddr ${RPCADDR} --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum,istanbul --rpcport 22000 --port 21000 --istanbul.requesttimeout 10000  --ethstats ${IDENTITY}:bb98a0b6442386d0cdf8a31b267892c1@netstats.telsius.alastria.io:80 --verbosity 3 --vmdebug --emitcheckpoints --targetgaslimit 8000000 --syncmode full --gcmode ${GCMODE} --vmodule consensus/istanbul/core/core.go=5 --nodiscover ${INFLUX_METRICS}"
fi

if [ "${NODE_TYPE}" == "general" ] && [ ! -z "$CONSTELLATION" ]; then
    echo "[*] Starting Constellation node"
    nohup constellation-node ~/alastria/data/constellation/constellation.conf 2>> ~/alastria/logs/constellation"${TIME}".log &
    check_constellation_isStarted
fi

echo "[*] Starting Geth node"
if [[ "${NODE_TYPE}" == "general" ]]; then
    PRIVATE_CONFIG=~/alastria/data/constellation/constellation.conf 
    nohup constellation-node ~/alastria/data/constellation/constellation.conf 2>> ~/alastria/logs/constellation"${TIME}".log &
    nohup env geth --datadir ~/alastria/data ${GLOBAL_ARGS} 2>> ~/alastria/logs/quorum"${TIME}".log &
fi
if [[ "${NODE_TYPE}" == "validator" ]]; then
    nohup geth --datadir ~/alastria/data ${GLOBAL_ARGS} --maxpeers 100 --mine --minerthreads $(grep -c "processor" /proc/cpuinfo) 2>> ~/alastria/logs/quorum"${TIME}".log &
fi
if [[ "${NODE_TYPE}" == "bootnode" ]]; then
    nohup geth --datadir ~/alastria/data ${GLOBAL_ARGS} --maxpeers 200 2>> ~/alastria/logs/quorum"${TIME}".log &
fi