#!/bin/bash
set -e

if [ $# -eq 0 ]; then
    exec /usr/sbin/collectd -f
fi

exec "$@"
