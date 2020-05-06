#!/bin/bash
set -e

if [ "$1" = 'collectd' ]; then
    exec /usr/sbin/collectd -f
fi

exec "$@"
