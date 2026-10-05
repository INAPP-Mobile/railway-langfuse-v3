#!/bin/sh
# S3 (RustFS) entrypoint for Langfuse. Replaces the old MinIO entrypoint, which
# invoked the `minio` binary — that image and its binary download endpoint are
# both gone (Docker Hub repo deleted; dl.min.io returns 410 Gone).
#
# Address/console config comes from RUSTFS_ADDRESS, RUSTFS_CONSOLE_ADDRESS and
# RUSTFS_CONSOLE_ENABLE in the Dockerfile rather than CLI flags, to stay
# compatible with the upstream image's own argument parsing.
#
# Starts as root because Railway mounts volumes root-owned; it fixes ownership
# and then drops to the unprivileged `rustfs` uid for the server itself.
set -e

DATA_DIR="${MINIO_DATA_DIR:-/data}"

# RustFS reads RUSTFS_ACCESS_KEY / RUSTFS_SECRET_KEY, but the template (and
# Langfuse's own S3_* references to ${{minio.MINIO_ROOT_*}}) already supply
# MINIO_ROOT_USER / MINIO_ROOT_PASSWORD. Map them so those existing
# cross-service references keep working with no template edits.
export RUSTFS_ACCESS_KEY="${RUSTFS_ACCESS_KEY:-${MINIO_ROOT_USER:-minio}}"
export RUSTFS_SECRET_KEY="${RUSTFS_SECRET_KEY:-${MINIO_ROOT_PASSWORD}}"
export RUSTFS_VOLUMES="${DATA_DIR}"

# No bucket subdirectory is pre-created here: buckets are created over the S3
# API, and creating a same-named directory on disk confuses the object store
# into treating it as an existing bucket with foreign metadata.
mkdir -p "${DATA_DIR}" "${RUSTFS_OBS_LOG_DIRECTORY:-/logs}"
chown -R 10001:10001 "${DATA_DIR}" "${RUSTFS_OBS_LOG_DIRECTORY:-/logs}" 2>/dev/null || true

# Fail loudly and early if storage is unusable, instead of starting a server
# that crash-loops with no explanation in the deploy logs.
if [ ! -w "${DATA_DIR}" ]; then
  echo "[s3-entrypoint] FATAL: ${DATA_DIR} is not writable" >&2
  exit 1
fi

# NOTE: the server deliberately stays on uid 0. The bundled setpriv in this
# base image is a stub that rejects every invocation form, and running as root is
# required regardless because Railway mounts the volume root-owned. Skip the
# privilege drop rather than shipping a broken one.
echo "[s3-entrypoint] data dir: ${DATA_DIR}"
echo "[s3-entrypoint] access key configured: ${RUSTFS_ACCESS_KEY}"
echo "[s3-entrypoint] starting S3 server on :9000 (console :9001)"
exec rustfs "${DATA_DIR}"