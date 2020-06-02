#!/bin/bash
set -u
set -e
TMPFILE="/tmp/$(basename $0).$$.tmp"
tmpfile=$(mktemp /tmp/updatePerm.XXXXXX)
NODE_TYPE="$1"
DESTDIR="$HOME/alastria/data/"
DATADIR="$HOME/alastria-node/data/"

echo "[" > $TMPFILE

if [ "$NODE_TYPE" == "bootnode" ]; then
   cat $DATA_DIR/boot-nodes.json $DATA_DIR/validator-nodes.json $DATA_DIR/regular-nodes.json >> $TMPFILE
fi
if [ "$NODE_TYPE" == "validator" ]; then
     cat $DATA_DIR/boot-nodes.json $DATA_DIR/validator-nodes.json >> $TMPFILE
fi
if [ "$NODE_TYPE" == "general" ]; then
     cat $DATA_DIR/boot-nodes.json >> $TMPFILE
fi
cat $TMPFILE | sed '$s/,$//' > $tmpfile
echo "]" >> $tmpfile

cat $tmpfile > $DESTDIR/static-nodes.json
cp $DESTDIR/static-nodes.json $DESTDIR/permissioned-nodes.json

rm $TMPFILE
rm $tmpfile

# Gracefull restart for geth
# TOBE Tested
killall -HUP geth

set +u
set +e