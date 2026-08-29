FROM docker.io/clickhouse/clickhouse-server:25.12

# ClickHouse server
# All env vars are set via Railway's variable system

# Fix volume permissions for Railway
USER root
RUN chown -R clickhouse:clickhouse /var/lib/clickhouse /var/log/clickhouse-server /etc/clickhouse-server 2>/dev/null || true
USER clickhouse

HEALTHCHECK --interval=5s --timeout=5s --retries=10 --start-period=30s \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8123/ping || exit 1

EXPOSE 8123 9000
