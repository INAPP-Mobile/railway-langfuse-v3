#!/bin/bash
set -e

echo "=== Checking user/permissions ==="
echo "Running as: $(id)"
ls -la /var/lib/clickhouse 2>/dev/null | head -5 || echo "cannot list"
ls -la /var/log/clickhouse-server 2>/dev/null | head -5 || echo "cannot list"

echo "=== Checking for gosu/runuser/setpriv ==="
which gosu runuser setpriv su 2>/dev/null || echo "none found"

echo "=== Env ==="
env | grep -i clickhouse || echo "no clickhouse env"
