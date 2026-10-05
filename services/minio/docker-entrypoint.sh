#!/bin/sh
# S3 (RustFS) entrypoint for Langfuse: pre-create the bucket directory, then
# exec the server. Replaces the old MinIO entrypoint, which invoked the `minio`
# binary — that image and binary are gone from all upstream registries.
#
# Address/console config is supplied via RUSTFS_ADDRESS, RUSTFS_CONSOLE_ADDRESS
# and RUSTFS_CONSOLE_ENABLE in the Dockerfile, not as flags, so this stays
# compatible with the upstream image's own argument parsing.
set -e

BUCKET="${MINIO_BUCKET:-langfuse}"
DATA_DIR="${MINIO_DATA_DIR:-/data}"

# RustFS reads RUSTFS_ACCESS_KEY / RUSTFS_SECRET_KEY, but the template (and
# Langfuse's own S3_* references to ${{minio.MINIO_ROOT_*}}) already supply
# MINIO_ROOT_USER / MINIO_ROOT_PASSWORD. Map them so the existing
# cross-service references keep working unchanged.
export RUSTFS_ACCESS_KEY="${RUSTFS_ACCESS_KEY:-${MINIO_ROOT_USER:-minio}}"
export RUSTFS_SECRET_KEY="${RUSTFS_SECRET_KEY:-${MINIO_ROOT_PASSWORD}}"

# Pre-create bucket directory so it exists from first request
mkdir -p "${DATA_DIR}/${BUCKET}"
echo "[s3-entrypoint] bucket directory ready at ${DATA_DIR}/${BUCKET}"
echo "[s3-entrypoint] access key configured: ${RUSTFS_ACCESS_KEY}"

# Railway's startCommand replaces CMD, so a real override arrives as args here.
# The default CMD is the single arg "/data" — only treat *other* args as an
# override, otherwise we would try to exec the volume directory.
if [ "$#" -gt 0 ] && [ "$1" != "/data" ]; then
  echo "[s3-entrypoint] running overridden command: $*"
  exec "$@"
fi

echo "[s3-entrypoint] starting S3 server on :9000 (console :9001)"
exec rustfs "${DATA_DIR}"