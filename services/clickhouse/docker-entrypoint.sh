#!/bin/bash
set -e

echo "=== Fixing volume ownership ==="
chown -R clickhouse:clickhouse /var/lib/clickhouse 2>/dev/null || true
chown -R clickhouse:clickhouse /var/log/clickhouse-server 2>/dev/null || true
mkdir -p /var/lib/clickhouse/coordination/log /var/lib/clickhouse/coordination/snapshots
chown -R clickhouse:clickhouse /var/lib/clickhouse/coordination

echo "=== Delegating to official entrypoint ==="
exec /entrypoint.sh "$@"
