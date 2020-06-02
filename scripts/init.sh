#!/bin/bash

set -e

MESSAGE='Usage: init <mode> <node-type> <node-name> <password>
    mode: CURRENT_HOST_IP | auto | backup
    node-type: validator | general | bootnode
    node-name: NODE_NAME (example: Alastria)'

# alejandro.alfonso
# hay un cuarto argumento, PASSWORD
if ( [ $# -ne 4 ] ); then
    echo "${MESSAGE}"
    exit 0
fi

CURRENT_HOST_IP="$1"
NODE_TYPE="$2"
NODE_NAME="$3"
if ( [ -z "$4" ] ); then
	ACCOUNT_PASSWORD="Passw0rd"
else
	ACCOUNT_PASSWORD="$4"
fi
CONSTELLATION_PORT="9000"


if ( [ "auto" == "$1" ]); then
    echo "[*] Autodiscovering public host IP ..."
    CURRENT_HOST_IP="$(curl -s --retry 2 icanhazip.com)"
    echo "Public host IP found: ${CURRENT_HOST_IP}"
fi

generate_conf() {
   #define parameters which are passed in.
   NODE_IP="$1"
   CONSTELLATION_PORT="$2"
   OTHER_NODES="$3"

   #define the template.
   cat  << EOF
# Externally accessible URL for this node (this is what's advertised)
url = "https://$NODE_IP:$CONSTELLATION_PORT/"

# Port to listen on for the public API
port = $CONSTELLATION_PORT

# Socket file to use for the private API / IPC
socket = "/root/alastria/data/constellation/constellation.ipc"

# Initial (not necessarily complete) list of other nodes in the network.
# Constellation will automatically connect to other nodes not in this list
# that are advertised by the nodes below, thus these can be considered the
# "boot nodes."
othernodes = $OTHER_NODES

# The set of public keys this node will host
publickeys = ["/root/alastria/data/constellation/keystore/node.pub"]

# The corresponding set of private keys
privatekeys = ["/root/alastria/data/constellation/keystore/node.key"]

# Optional file containing the passwords to unlock the given privatekeys
# (one password per line -- add an empty line if one key isn't locked.)
passwords = "/root/alastria/data/passwords.txt"

# Where to store payloads and related information
storage = "/root/alastria/data/constellation/data"

# Verbosity level (each level includes all prior levels)
#   - 0: Only fatal errors
#   - 1: Warnings
#   - 2: Informational messages
#   - 3: Debug messages
verbosity = 2

EOF
}

update_constellation_nodes() {
    NODE_IP="$1"
    CONSTELLATION_PORT="$2"
    URL=",
   \"https://$NODE_IP:$CONSTELLATION_PORT/\"
]"
    CONSTELLATION_NODES=${CONSTELLATION_NODES::-2}
    CONSTELLATION_NODES="$CONSTELLATION_NODES$URL"
    echo "$CONSTELLATION_NODES" > ~/alastria/data/constellation-nodes.json
}


echo "[*] Cleaning up temporary data directories, as 1st run detected."

mkdir -p ~/alastria/data/{geth,constellation}
mkdir -p ~/alastria/data/constellation/{data,keystore}
mkdir -p ~/alastria/logs

echo $ACCOUNT_PASSWORD > ~/alastria/data/passwords.txt

echo "[*] Initializing quorum"
geth --datadir ~/alastria/data init ~/alastria-node/data/genesis.json

echo "[*] Initializing bootnode"
cd ~/alastria/data/geth
bootnode -genkey nodekey
ENODE_KEY=$(bootnode -nodekey nodekey -writeaddress)

if [ ! -f ~/alastria-node/data/keys/data/geth/nodekey ]; then
    echo "[*] creating dir if not created and set nodekey"
    mkdir -p ~/alastria-node/data/keys/data/geth
    cp nodekey ~/alastria-node/data/keys/data/geth/nodekey
fi

if ( [ "general" == "$NODE_TYPE" ] ); then

    echo "[*] Inicialite geth..."
    geth --datadir ~/alastria/data --password ~/alastria/data/passwords.txt account new

      if ( [ "${ENABLE_CONSTELLATION}" == "true" ] ); then

        CONSTELLATION_NODES=$(cat ~/alastria-node/data/constellation-nodes.json)

        echo "[*] Initializing Constellation node."
        mkdir -p ~/alastria/data/keystore
        update_constellation_nodes ${CURRENT_HOST_IP} ${CONSTELLATION_PORT}
        generate_conf ${CURRENT_HOST_IP} ${CONSTELLATION_PORT} "${CONSTELLATION_NODES}" > ~/alastria/data/constellation/constellation.conf

        cd ~/alastria/data/constellation/keystore
        cat ~/alastria/data/passwords.txt | /usr/local/constellation-0.3.2-ubuntu1604/constellation-node --generatekeys=node
        if [ ! -f ~/alastria-node/data/keys/data/constellation/keystore ]; then

            echo "[*] Creating dir if not created, and set keystore"
            mkdir -p ~/alastria-node/data/keys/data/constellation
            # cp -rf . ~/alastria-node/data/keys/data/constellation/keystore
            cp -rf  ~/alastria/data/keystore ~/alastria-node/data/keys/data/

        fi
    fi
fi

if ( [ "validator" == "$NODE_TYPE" ]); then
    rm -rf ~/alastria/data/keystore
fi

echo "[*] Finish initiation."
echo "$NODE_NAME" > ~/alastria/data/IDENTITY
echo "$NODE_TYPE" > ~/alastria/data/NODE_TYPE

echo "[*] Your ENODE -> 'enode://${ENODE_KEY}@${CURRENT_HOST_IP}:21000?discport=0'"

echo "[*] Initialization was completed successfully."
echo " "
echo "      Update DIRECTORY_REGULAR.md, DIRECTORY_VALIDATOR.md or DIRECTORY_BOOTNODES.md from alastria-node repository and send a Pull Request."
echo "      Don't forget the .json files in data folder!."
echo " "

set +u
set +e