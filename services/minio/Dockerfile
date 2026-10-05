# MinIO's Docker Hub repository was deleted in 2026 (upstream archived the
# project and removed all published images), so minio/minio no longer pulls.
# RustFS is a drop-in S3-compatible replacement: same S3 API, same path-style
# addressing, and it serves the same /minio/health/live endpoint.
FROM rustfs/rustfs:latest

# The base image runs as non-root `rustfs`, but Railway mounts volumes
# root-owned. Without this chown the service cannot write to /data and
# crash-loops with EACCES on startup.
USER root
RUN mkdir -p /data /logs && chown -R rustfs:rustfs /data /logs
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
USER rustfs

ENV RUSTFS_VOLUMES=/data \
    RUSTFS_OBS_LOG_DIRECTORY=/logs \
    RUSTFS_ADDRESS=0.0.0.0:9000 \
    RUSTFS_CONSOLE_ADDRESS=0.0.0.0:9001 \
    RUSTFS_CONSOLE_ENABLE=true

HEALTHCHECK --interval=10s --timeout=3s --retries=5 --start-period=15s \
  CMD curl -f http://127.0.0.1:9000/minio/health/live || exit 1

EXPOSE 9000
EXPOSE 9001

# The upstream image sets ENTRYPOINT ["/entrypoint.sh"] with CMD ["rustfs"], so
# a CMD of our own would be passed to the entrypoint as arguments and the server
# would try to treat "/docker-entrypoint.sh" as a volume path. Override the
# ENTRYPOINT instead and keep the arg explicit.
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/data"]