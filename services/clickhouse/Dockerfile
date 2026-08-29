FROM clickhouse/clickhouse-server:25.12

# ClickHouse for Railway - no volumes, container fs only
# Official image already handles clickhouse user/perms correctly

USER root
RUN mkdir -p /var/lib/clickhouse /var/log/clickhouse-server \
    && chown -R clickhouse:clickhouse /var/lib/clickhouse /var/log/clickhouse-server

HEALTHCHECK --interval=10s --timeout=10s --retries=30 --start-period=120s \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8123/ping || exit 1

EXPOSE 8123 9000

USER clickhouse
ENTRYPOINT ["clickhouse-server"]
CMD ["--config-file=/etc/clickhouse-server/config.xml"]
