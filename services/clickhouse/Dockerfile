FROM docker.io/clickhouse/clickhouse-server:25.12

# ClickHouse for Railway
# Uses container filesystem (no volume) to avoid permission issues

HEALTHCHECK --interval=5s --timeout=5s --retries=10 --start-period=30s \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8123/ping || exit 1

EXPOSE 8123 9000
