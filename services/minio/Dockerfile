FROM docker.io/minio/minio:RELEASE.2025-07-17T12-07-51Z

# MinIO for Railway - use local container fs to avoid overlayfs issues
# For production, attach external S3 via env vars

USER root
RUN mkdir -p /minio-local/langfuse && chown -R 1000:1000 /minio-local
USER 1000

HEALTHCHECK --interval=1s --timeout=5s --retries=5 --start-period=1s \
  CMD mc ready local || exit 1

EXPOSE 9000 9001

CMD ["minio", "server", "--address", ":9000", "--console-address", ":9001", "/minio-local"]
