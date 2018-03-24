#!/bin/sh

export HOST_IP=`/sbin/ip route|/usr/bin/awk '/default/ { print $3 }'`

exec "$@"
