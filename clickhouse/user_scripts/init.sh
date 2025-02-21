#!/bin/bash
chown -R 101:101 /var/lib/clickhouse
exec /entrypoint.sh
