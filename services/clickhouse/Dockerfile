FROM bitnami/clickhouse:24.8

# ClickHouse for Railway - bitnami image supports arbitrary UID
# Data stored in container fs (ephemeral) - for production, attach Railway volume

RUN mkdir -p /bitnami/clickhouse/data /bitnami/clickhouse/logs

HEALTHCHECK --interval=5s --timeout=10s --retries=20 --start-period=60s \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8123/ping || exit 1

EXPOSE 8123 9000
