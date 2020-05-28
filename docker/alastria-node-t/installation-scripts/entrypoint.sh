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
	git clone https://github.com/alastria/alastria-node -b alastria-node-t
	git clone https://github.com/alastria/alastria-access-point
	# alejandro.alfonso
	# WIP
	cd /root/alastria-node/scripts
	./init.sh auto $NODE_TYPE $NODE_NAME
else
	echo "[*] Updating static-nodes and permissioned-nodes"
	# alejandro.alfonso
	# WIP
	# hacemos aquí un git pull de los repos?
	cd /root/alastria-node && git pull
	cd /root/alastria-access-point && git pull
	cd /root/alastria-node/scripts
	./updatePerm.sh $NODE_TYPE
	# alejandro.alfonso
	# consultar con carlos
	#./update-nginf.sh $NODE_TYPE
fi

echo "[*] Starting nginx"
# alejandro.alfonso
# WIP
/etc/init.d/nginx start
# (actulizar nginf.conf)
# nginx -g "daemon off;"

echo "[*] Starting geth... welcome to Alastria-T!"

cd /root/alastria-node/scripts
ARGS="--watch --local-rpc"
exec ./start.sh $ARGS &

# alejandro.alfonso
# WIP ... sleep hasta tener "start.sh" refinado
sleep infinity

child=$!
wait "$child"
