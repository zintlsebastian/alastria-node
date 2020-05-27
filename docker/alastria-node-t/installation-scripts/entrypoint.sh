#!/bin/bash

_term() {
    pkill -f geth
    wait
}

trap _term SIGTERM

# alejandro.alfonso
# cambiar a rutas absolutas

if [ ! -f ~/alastria/data/IDENTITY ]; then
	echo "[*] First run"
	cd /root
	#git clone https://github.com/alastria/alastria-node -b testnet2
        git clone https://github.com/alastria/alastria-node -b alastria-node-t
	# alejandro.alfonso
	# WIP
	cd /root/alastria-node/scripts
	./init.sh auto $NODE_TYPE $NODE_NAME
else
	echo "[*] Updating static-nodes and permissioned-nodes"
	# alejandro.alfonso
	# WIP
	# hacemos aquí un git pull de los repos?
	# ./updatePerm.sh $NODE_TYPE
fi

# alejandro.alfonso
# WIP
# /etc/init.d/nginx start

# configurar y arrancar aqui ngnix
# git clone https://github.com/alastria/alastria-access-point
# nginx -g "daemon off;"
# alejandro.alfonso - quito el monitor
#    ARGS="--watch --local-rpc --no-monitor"
#exec ./start.sh $ARGS &

#echo "./start.sh $ARGS &"

# alejandro.alfonso
# WIP ... sleep hasta tener "start.sh"
sleep infinity

child=$!
wait "$child"
