# MinIO's Docker Hub repository was deleted in 2026 (upstream archived the
# project and removed all published images), so minio/minio no longer pulls.
# RustFS is a drop-in S3-compatible replacement: same S3 API, same path-style
# addressing, and it serves the same /minio/health/live endpoint, so the
# template's healthcheckPath and FORCE_PATH_STYLE wiring are unchanged.
FROM rustfs/rustfs:latest

# The base image ends with `USER rustfs` (uid 10001), so COPY lands files owned
# by root and the chmod below fails with "Operation not permitted" — which
# fails the whole build. Switch to root for the file operations; the entrypoint
# drops back to uid 10001 before exec'ing the server.
USER root

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

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
# a CMD of our own would be handed to that entrypoint as arguments and the
# server would try to treat the script path as a volume. Override the
# ENTRYPOINT instead.
#
# Run as root (not the image's default `rustfs` user): Railway mounts volumes
# root-owned, and a non-root process cannot write the S3 metadata there. The
# entrypoint drops to uid 10001 only after fixing ownership of /data.
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/data"]