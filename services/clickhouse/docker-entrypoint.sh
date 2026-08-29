#!/bin/bash
set -e

# Create coordination directories
mkdir -p /var/lib/clickhouse/coordination/log /var/lib/clickhouse/coordination/snapshots
chown -R clickhouse:clickhouse /var/lib/clickhouse/coordination

# Show any previous error log for debugging
if [ -f /var/log/clickhouse-server/clickhouse-server.err.log ]; then
    echo "=== Previous error log ==="
    cat /var/log/clickhouse-server/clickhouse-server.err.log
    echo "=== End error log ==="
fi

# Delegate to official entrypoint
exec /entrypoint.sh "$@"
