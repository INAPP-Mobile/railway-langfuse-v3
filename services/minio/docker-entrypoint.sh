#!/bin/sh
# MinIO entrypoint for Langfuse: pre-create the bucket directory, then exec server.
set -e

BUCKET="${MINIO_BUCKET:-langfuse}"
DATA_DIR="${MINIO_DATA_DIR:-/data}"

# Pre-create bucket directory so it exists from first request
mkdir -p "${DATA_DIR}/${BUCKET}"
echo "[minio-entrypoint] bucket directory ready at ${DATA_DIR}/${BUCKET}"

echo "[minio-entrypoint] starting minio server on :9000 (console :9001)"
exec minio server "${DATA_DIR}" \
  --address 0.0.0.0:9000 \
  --console-address 0.0.0.0:9001
