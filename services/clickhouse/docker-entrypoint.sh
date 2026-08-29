#!/bin/bash
set -e

# Create coordination directories after volume is mounted
mkdir -p /var/lib/clickhouse/coordination/log
mkdir -p /var/lib/clickhouse/coordination/snapshots
chown -R clickhouse:clickhouse /var/lib/clickhouse/coordination

# Delegate to the official entrypoint (handles users.xml generation + server start)
exec /entrypoint.sh "$@"
