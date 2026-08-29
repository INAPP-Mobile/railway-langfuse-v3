FROM docker.io/clickhouse/clickhouse-server:25.12

# ClickHouse server
# All env vars are set via Railway's variable system
# user 101:101 matches official compose for volume permissions
USER 101:101

HEALTHCHECK --interval=5s --timeout=5s --retries=10 --start-period=1s \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8123/ping || exit 1

EXPOSE 8123 9000
