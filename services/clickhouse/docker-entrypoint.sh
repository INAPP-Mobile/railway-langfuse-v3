#!/bin/bash
set -e

# Create coordination directories after volume is mounted
mkdir -p /var/lib/clickhouse/coordination/log
mkdir -p /var/lib/clickhouse/coordination/snapshots
chown -R clickhouse:clickhouse /var/lib/clickhouse/coordination

# Generate users.xml from environment variables
python3 -c "
import os, sys
user = os.environ.get('CLICKHOUSE_USER', 'default')
pw = os.environ.get('CLICKHOUSE_PASSWORD', '')
xml = '''<?xml version=\"1.0\"?>
<clickhouse>
    <profiles>
        <default>
            <max_memory_usage>10000000000</max_memory_usage>
            <use_uncompressed_cache>0</use_uncompressed_cache>
            <load_balancing>random</load_balancing>
        </default>
    </profiles>
    <users>
        <''' + user + '''>
            <password>''' + pw + '''</password>
            <networks>
                <ip>::/0</ip>
            </networks>
            <profile>default</profile>
            <quota>default</quota>
            <access_management>1</access_management>
        </''' + user + '''>
    </users>
</clickhouse>
'''
with open('/etc/clickhouse-server/users.xml', 'w') as f:
    f.write(xml)
"

chown clickhouse:clickhouse /etc/clickhouse-server/users.xml

# Execute the original entrypoint (handles DB creation from CLICKHOUSE_DB)
exec /entrypoint.sh "$@"
