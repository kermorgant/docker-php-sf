#!/bin/sh

export HOST_IP=`/sbin/ip route|awk '/default/ { print $3 }'`

exec "$@"
