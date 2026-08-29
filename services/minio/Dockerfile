FROM docker.io/minio/minio:RELEASE.2025-07-17T12-07-51Z

# MinIO for Railway
# Uses container filesystem (no volume) to avoid overlayfs rename issues
# Data is ephemeral - for production, attach external S3

USER root
RUN mkdir -p /minio-data/langfuse && chown -R 1000:1000 /minio-data
USER 1000

ENV MINIO_VOLUMES="/minio-data"
ENV MINIO_STORAGE_CLASS_STANDARD="EC:0"
ENV MINIO_BROWSER="on"

HEALTHCHECK --interval=1s --timeout=5s --retries=5 --start-period=1s \
  CMD mc ready local || exit 1

EXPOSE 9000 9001
