FROM docker.io/minio/minio

# MinIO for Railway
# The volume at /data is mounted as root, so we need root to create subdirs
USER root
RUN mkdir -p /data && chmod 777 /data

# Create entrypoint script that drops privileges properly
RUN echo '#!/bin/sh' > /entrypoint.sh && \
    echo 'set -e' >> /entrypoint.sh && \
    echo 'mkdir -p /data/langfuse' >> /entrypoint.sh && \
    echo 'chmod 777 /data' >> /entrypoint.sh && \
    echo 'chown -R minio:minio /data' >> /entrypoint.sh && \
    echo 'exec su -s /bin/sh minio -c "minio server --address :9000 --console-address :9001 /data"' >> /entrypoint.sh && \
    chmod +x /entrypoint.sh

HEALTHCHECK --interval=5s --timeout=5s --retries=10 --start-period=30s \
  CMD mc ready local || exit 1

EXPOSE 9000 9001

ENTRYPOINT ["/entrypoint.sh"]
