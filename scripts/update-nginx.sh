#!/bin/bash
set -u
set -e

cp /root/alastria-access-point/nginx/conf.d/access-point.conf /etc/nginx/conf.d/access-point.conf
touch /etc/nginx/conf.d/whitelist
rm -f /etc/nginx/sites-enabled/default

set +u
set +e