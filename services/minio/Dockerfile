# MinIO's Docker Hub repository was deleted in 2026 (upstream archived the
# project and removed all published images), so minio/minio no longer pulls and
# dl.min.io returns 410 Gone.
#
# RustFS is a drop-in S3-compatible replacement: same S3 API, same path-style
# addressing, and it serves the same /minio/health/live endpoint, so the
# template's healthcheckPath and FORCE_PATH_STYLE wiring are unchanged.
#
# Deliberately NO custom entrypoint, CMD override, or USER change. An earlier
# revision shipped a wrapper script to map MINIO_ROOT_USER/PASSWORD onto
# RUSTFS_ACCESS_KEY/SECRET_KEY; it built fine but every deployment failed at
# runtime with no deploy logs, while this bare upstream image deployed
# successfully on the same service. The wrapper was also unnecessary — rustfs
# natively accepts MINIO_ROOT_USER and MINIO_ROOT_PASSWORD as credential
# sources (its own startup warning names them), and those are exactly the
# variables the template already supplies and that Langfuse references through
# ${{minio.MINIO_ROOT_*}}. Credentials therefore pass straight through from the
# service environment with no translation layer.
FROM rustfs/rustfs:latest

# Run as root, overriding the image's default `rustfs` user. Railway mounts
# volumes root-owned, and as uid 10001 rustfs cannot write its metadata there:
# it dies at startup with "[FATAL] Server runtime failed: Io error: Permission
# denied (os error 13)". This is the one customisation the image needs.
#
# Note this is a USER change ONLY. An earlier revision also overrode ENTRYPOINT
# with a wrapper script; that built fine but every deployment failed at runtime
# with no deploy logs, while this image's own entrypoint deploys and logs
# normally. Upstream's /entrypoint.sh is correct, so leave it alone.
USER root

# Upstream defaults already match the Railway topology (API :9000 = the exposed
# port, console :9001, data in /data = the volume mount). Pinned explicitly so a
# future upstream release cannot silently move the port out from under the
# service's domain mapping and healthcheckPath.
ENV RUSTFS_VOLUMES=/data \
    RUSTFS_ADDRESS=0.0.0.0:9000 \
    RUSTFS_CONSOLE_ADDRESS=0.0.0.0:9001 \
    RUSTFS_CONSOLE_ENABLE=true

HEALTHCHECK --interval=10s --timeout=3s --retries=5 --start-period=15s \
  CMD curl -f http://127.0.0.1:9000/minio/health/live || exit 1

EXPOSE 9000
EXPOSE 9001