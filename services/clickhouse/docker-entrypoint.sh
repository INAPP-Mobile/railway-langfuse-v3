#!/bin/bash
set -e

# Dump previous error log for debugging
if [ -f /var/log/clickhouse-server/clickhouse-server.err.log ]; then
    echo "=== Previous clickhouse error log ==="
    tail -100 /var/log/clickhouse-server/clickhouse-server.err.log
    echo "=== End error log ==="
fi

# Remove potentially corrupted keeper state from previous runs
rm -rf /var/lib/clickhouse/coordination/log/*
rm -rf /var/lib/clickhouse/coordination/snapshots/*

# Create coordination directories
mkdir -p /var/lib/clickhouse/coordination/log /var/lib/clickhouse/coordination/snapshots
chown -R clickhouse:clickhouse /var/lib/clickhouse/coordination

# Delegate to official entrypoint
exec /entrypoint.sh "$@"
