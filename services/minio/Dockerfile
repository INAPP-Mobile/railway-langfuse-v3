FROM bitnami/minio:latest

# Create the langfuse bucket before starting
USER root
RUN mkdir -p /data/langfuse && chown -R 1001:1001 /data
USER 1001

HEALTHCHECK --interval=1s --timeout=5s --retries=5 --start-period=1s \
  CMD mc ready local || exit 1

EXPOSE 9000 9001
