#!/bin/bash
set -e

# Create coordination directories after volume is mounted
mkdir -p /var/lib/clickhouse/coordination/log
mkdir -p /var/lib/clickhouse/coordination/snapshots
chown -R clickhouse:clickhouse /var/lib/clickhouse/coordination

# Generate users.xml from environment variables so Railway-injected
# CLICKHOUSE_USER / CLICKHOUSE_PASSWORD are honored at runtime.
cat > /etc/clickhouse-server/users.xml <<XMLEOF
<?xml version="1.0"?>
<clickhouse>
    <profiles>
        <default>
            <max_memory_usage>10000000000</max_memory_usage>
            <use_uncompressed_cache>0</use_uncompressed_cache>
            <load_balancing>random</load_balancing>
        </default>
    </profiles>
    <users>
        <${CLICKHOUSE_USER}>
            <password>${CLICKHOUSE_PASSWORD}</password>
            <networks>
                <ip>::/0</ip>
            </networks>
            <profile>default</profile>
            <quota>default</quota>
            <access_management>1</access_management>
        </${CLICKHOUSE_USER}>
    </users>
</clickhouse>
XMLEOF
chown clickhouse:clickhouse /etc/clickhouse-server/users.xml

# Execute the original entrypoint (handles DB creation from CLICKHOUSE_DB)
exec /entrypoint.sh "$@"
