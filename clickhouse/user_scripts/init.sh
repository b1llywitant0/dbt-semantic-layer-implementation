#!/bin/bash
chown -R 101:101 /var/lib/clickhouse
chmod +x /etc/clickhouse-server/functions.xml
chmod +x /var/lib/clickhouse/user_scripts/*
exec /entrypoint.sh
