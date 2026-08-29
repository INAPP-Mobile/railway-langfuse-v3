FROM clickhouse/clickhouse-server:24.8

USER root

COPY keeper.xml /etc/clickhouse-server/config.d/keeper.xml
RUN chown clickhouse:clickhouse /etc/clickhouse-server/config.d/keeper.xml \
    && mkdir -p /var/lib/clickhouse/coordination/log /var/lib/clickhouse/coordination/snapshots \
    && chown -R clickhouse:clickhouse /var/lib/clickhouse

HEALTHCHECK --interval=10s --timeout=10s --retries=30 --start-period=120s \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8123/ping || exit 1

EXPOSE 8123 9000 9181
