#!/bin/bash
set -e

echo "=== Pre-start setup ==="

# Fix volume ownership
chown -R clickhouse:clickhouse /var/lib/clickhouse 2>/dev/null || true
chown -R clickhouse:clickhouse /var/log/clickhouse-server 2>/dev/null || true
mkdir -p /var/lib/clickhouse/coordination/log /var/lib/clickhouse/coordination/snapshots
chown -R clickhouse:clickhouse /var/lib/clickhouse/coordination

# Clear corrupted keeper state from previous crashes
rm -rf /var/lib/clickhouse/coordination/log/* /var/lib/clickhouse/coordination/snapshots/* 2>/dev/null || true

echo "=== Delegating to official entrypoint (handles user switch) ==="
exec /entrypoint.sh "$@"
