#!/bin/bash
set -e

# Create coordination directories after volume is mounted
mkdir -p /var/lib/clickhouse/coordination/log
mkdir -p /var/lib/clickhouse/coordination/snapshots
chown -R clickhouse:clickhouse /var/lib/clickhouse/coordination

# Generate users.xml from environment variables using printf (bash builtin)
USER_NAME="${CLICKHOUSE_USER:-default}"
USER_PASSWORD="${CLICKHOUSE_PASSWORD:-}"

# XML-escape the password (using sed which is a coreutil)
esc_pw=$(printf '%s' "$USER_PASSWORD" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g; s/"/\&quot;/g; s/'"'"'/\&apos;/g')
esc_user=$(printf '%s' "$USER_NAME" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g; s/"/\&quot;/g; s/'"'"'/\&apos;/g')

printf '<?xml version="1.0"?>\n' > /etc/clickhouse-server/users.xml
printf '<clickhouse>\n' >> /etc/clickhouse-server/users.xml
printf '    <profiles>\n' >> /etc/clickhouse-server/users.xml
printf '        <default>\n' >> /etc/clickhouse-server/users.xml
printf '            <max_memory_usage>10000000000</max_memory_usage>\n' >> /etc/clickhouse-server/users.xml
printf '            <use_uncompressed_cache>0</use_uncompressed_cache>\n' >> /etc/clickhouse-server/users.xml
printf '            <load_balancing>random</load_balancing>\n' >> /etc/clickhouse-server/users.xml
printf '        </default>\n' >> /etc/clickhouse-server/users.xml
printf '    </profiles>\n' >> /etc/clickhouse-server/users.xml
printf '    <users>\n' >> /etc/clickhouse-server/users.xml
printf '        <%s>\n' "$esc_user" >> /etc/clickhouse-server/users.xml
printf '            <password>%s</password>\n' "$esc_pw" >> /etc/clickhouse-server/users.xml
printf '            <networks>\n' >> /etc/clickhouse-server/users.xml
printf '                <ip>::/0</ip>\n' >> /etc/clickhouse-server/users.xml
printf '            </networks>\n' >> /etc/clickhouse-server/users.xml
printf '            <profile>default</profile>\n' >> /etc/clickhouse-server/users.xml
printf '            <quota>default</quota>\n' >> /etc/clickhouse-server/users.xml
printf '            <access_management>1</access_management>\n' >> /etc/clickhouse-server/users.xml
printf '        </%s>\n' "$esc_user" >> /etc/clickhouse-server/users.xml
printf '    </users>\n' >> /etc/clickhouse-server/users.xml
printf '</clickhouse>\n' >> /etc/clickhouse-server/users.xml

chown clickhouse:clickhouse /etc/clickhouse-server/users.xml

# Execute the original entrypoint (handles DB creation from CLICKHOUSE_DB)
exec /entrypoint.sh "$@"
