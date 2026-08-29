FROM docker.io/minio/minio

# MinIO for Railway
# Railway mounts volumes as root-owned; minio user (uid 1000) can't write.
# Fix: run entrypoint as root, fix permissions, then drop to minio user.
USER root

# Write entrypoint that fixes volume permissions at runtime
RUN printf '#!/bin/sh\n\
set -e\n\
# Fix permissions on the Railway-mounted volume\n\
chmod 777 /data\n\
mkdir -p /data/langfuse\n\
chown -R minio:minio /data\n\
# Drop to minio user and start server\n\
exec su -s /bin/sh minio -c "minio server --address :9000 --console-address :9001 /data"\n\
' > /entrypoint.sh && chmod +x /entrypoint.sh

HEALTHCHECK --interval=5s --timeout=5s --retries=10 --start-period=30s \
  CMD mc ready local || exit 1

EXPOSE 9000 9001

ENTRYPOINT ["/entrypoint.sh"]
