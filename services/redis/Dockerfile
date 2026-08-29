FROM docker.io/redis:7-alpine

# Require password and disable eviction for BullMQ
# REDIS_AUTH is injected by Railway at runtime via ${{secret(32)}}
CMD ["redis-server", "--requirepass", "${REDIS_AUTH}", "--maxmemory-policy", "noeviction"]

HEALTHCHECK --interval=3s --timeout=10s --retries=10 \
  CMD redis-cli -a "${REDIS_AUTH}" ping || exit 1

EXPOSE 6379
