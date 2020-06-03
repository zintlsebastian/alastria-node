#!/bin/bash

_term() {
    pkill -f geth
    wait
}

trap _term SIGTERM

if [ ! -f ~/alastria/data/IDENTITY ]; then
	echo "[*] First run"

	cd /root
	git clone https://github.com/alastria/alastria-node -b alastria-node-t
	git clone https://github.com/alastria/alastria-access-point
	
	/root/alastria-node/scripts/init.sh auto $NODE_TYPE $NODE_NAME $PASSWORD
else
	echo "[*] Updating repositories"
	
	cd /root/alastria-node && git pull
	cd /root/alastria-access-point && git pull
fi

echo "[*] Update nginx"
/root/alastria-node/scripts/update-nginx.sh $NODE_TYPE $NODE_NAME
echo "[*] Starting nginx"
/etc/init.d/nginx start

echo "[*] Update geth nodes"
/root/alastria-node/scripts/update-node.sh $NODE_TYPE $NODE_NAME
echo "[*] Starting geth node"
ARGS="--watch --local-rpc"
exec /root/alastria-node/scripts/start.sh $ARGS &

child=$!
wait "$child"

# dirty fix
/bin/sleep infinity