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
	
	cd /root/alastria-node/scripts
	./init.sh auto $NODE_TYPE $NODE_NAME
	./update-nginx.sh $NODE_TYPE $NODE_NAME
else
	echo "[*] Updating nodes"
	
	cd /root/alastria-node && git pull
	cd /root/alastria-access-point && git pull

	cd /root/alastria-node/scripts
	./update-node.sh $NODE_TYPE $NODE_NAME
	./update-nginx.sh $NODE_TYPE $NODE_NAME
fi

echo "[*] Starting nginx"
/etc/init.d/nginx start

echo "[*] Starting geth... welcome to Alastria-T!"
cd /root/alastria-node/scripts
ARGS="--watch --local-rpc"
exec ./start.sh $ARGS &

# until a start.sh refined scripts
sleep infinity
#child=$!
#wait "$child"
