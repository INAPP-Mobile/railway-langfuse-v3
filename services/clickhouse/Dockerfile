FROM clickhouse/clickhouse-server:25.12

USER root

# Keeper config as an include
COPY keeper.xml /etc/clickhouse-server/config.d/keeper.xml
RUN chown clickhouse:clickhouse /etc/clickhouse-server/config.d/keeper.xml

# Create coordination directories at build time
RUN mkdir -p /var/lib/clickhouse/coordination/log /var/lib/clickhouse/coordination/snapshots \
    && chown -R clickhouse:clickhouse /var/lib/clickhouse/coordination

HEALTHCHECK --interval=10s --timeout=10s --retries=30 --start-period=120s \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8123/ping || exit 1

EXPOSE 8123 9000 9181

# Custom entrypoint that logs everything
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["clickhouse-server", "--config-file=/etc/clickhouse-server/config.xml"]
