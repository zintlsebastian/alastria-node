#!/bin/bash
set -u
set -e

cp alastria-access-point/nginx/conf.d/access-point.conf /etc/nginx/conf.d/access-point.conf
touch /etc/nginx/conf.d/whitelist
rm /etc/nginx/sites-enabled/default
killall -HUP geth

set +u
set +e