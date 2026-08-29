#!/bin/bash
set -e

echo "=== ENTRYPOINT START (root) ==="

# Fix volume ownership (Railway mounts volumes as root)
chown -R clickhouse:clickhouse /var/lib/clickhouse 2>/dev/null || true
chown -R clickhouse:clickhouse /var/log/clickhouse-server 2>/dev/null || true

# Create coordination directories
mkdir -p /var/lib/clickhouse/coordination/log /var/lib/clickhouse/coordination/snapshots
chown -R clickhouse:clickhouse /var/lib/clickhouse/coordination

echo "=== Switching to clickhouse user ==="
exec gosu clickhouse /entrypoint.sh "$@"
