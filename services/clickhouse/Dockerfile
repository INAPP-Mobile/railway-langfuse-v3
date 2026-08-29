FROM clickhouse/clickhouse-server:25.12

# ClickHouse for Railway with built-in Keeper
# Enables ON CLUSTER syntax for Langfuse migrations

USER root

# Copy custom config with Keeper + cluster definition
COPY config.xml /etc/clickhouse-server/config.xml
RUN chown clickhouse:clickhouse /etc/clickhouse-server/config.xml

# Entrypoint that creates coordination directories then delegates to original entrypoint
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

HEALTHCHECK --interval=10s --timeout=10s --retries=30 --start-period=120s \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8123/ping || exit 1

EXPOSE 8123 9000 9181

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["clickhouse-server", "--config-file=/etc/clickhouse-server/config.xml"]
