#!/bin/bash
set -e

echo "=== ENTRYPOINT START ==="

# Show environment
echo "ENV: CLICKHOUSE_USER=$CLICKHOUSE_USER CLICKHOUSE_DB=$CLICKHOUSE_DB"
echo "ENV: CLICKHOUSE_PASSWORD set: $([ -n "$CLICKHOUSE_PASSWORD" ] && echo yes || echo no)"

# Dump previous error log
if [ -f /var/log/clickhouse-server/clickhouse-server.err.log ]; then
    echo "=== Previous clickhouse error log ==="
    tail -100 /var/log/clickhouse-server/clickhouse-server.err.log
    echo "=== End error log ==="
else
    echo "No previous err.log found"
fi

# Clear potentially corrupted state
rm -rf /var/lib/clickhouse/coordination/log/* /var/lib/clickhouse/coordination/snapshots/* 2>/dev/null || true
mkdir -p /var/lib/clickhouse/coordination/log /var/lib/clickhouse/coordination/snapshots
chown -R clickhouse:clickhouse /var/lib/clickhouse/coordination

echo "=== Delegating to /entrypoint.sh ==="
exec /entrypoint.sh "$@"
