#!/bin/bash
set -e

# Create coordination directories after volume is mounted
mkdir -p /var/lib/clickhouse/coordination/log
mkdir -p /var/lib/clickhouse/coordination/snapshots
chown -R clickhouse:clickhouse /var/lib/clickhouse/coordination

# Generate users.xml from environment variables using awk (no python needed)
USER_NAME="${CLICKHOUSE_USER:-default}"
USER_PASSWORD="${CLICKHOUSE_PASSWORD:-}"

# Use awk to safely generate XML with proper escaping
awk -v user="$USER_NAME" -v pw="$USER_PASSWORD" 'BEGIN {
    # XML-escape the password
    gsub(/&/, "\\&amp;", pw)
    gsub(/</, "\\&lt;", pw)
    gsub(/>/, "\\&gt;", pw)
    gsub(/"/, "\\&quot;", pw)
    gsub(/\x27/, "\\&apos;", pw)
    # XML-escape the username
    gsub(/&/, "\\&amp;", user)
    gsub(/</, "\\&lt;", user)
    gsub(/>/, "\\&gt;", user)
    gsub(/"/, "\\&quot;", user)
    gsub(/\x27/, "\\&apos;", user)
    printf "<?xml version=\"1.0\"?>\n"
    printf "<clickhouse>\n"
    printf "    <profiles>\n"
    printf "        <default>\n"
    printf "            <max_memory_usage>10000000000</max_memory_usage>\n"
    printf "            <use_uncompressed_cache>0</use_uncompressed_cache>\n"
    printf "            <load_balancing>random</load_balancing>\n"
    printf "        </default>\n"
    printf "    </profiles>\n"
    printf "    <users>\n"
    printf "        <%s>\n", user
    printf "            <password>%s</password>\n", pw
    printf "            <networks>\n"
    printf "                <ip>::/0</ip>\n"
    printf "            </networks>\n"
    printf "            <profile>default</profile>\n"
    printf "            <quota>default</quota>\n"
    printf "            <access_management>1</access_management>\n"
    printf "        </%s>\n", user
    printf "    </users>\n"
    printf "</clickhouse>\n"
}' > /etc/clickhouse-server/users.xml

chown clickhouse:clickhouse /etc/clickhouse-server/users.xml

# Execute the original entrypoint (handles DB creation from CLICKHOUSE_DB)
exec /entrypoint.sh "$@"
