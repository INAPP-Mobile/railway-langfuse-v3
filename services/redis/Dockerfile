FROM docker.io/redis:7-alpine

# Require password and disable eviction for BullMQ
CMD ["redis-server", "--requirepass", "${REDIS_AUTH:-myredissecret}", "--maxmemory-policy", "noeviction"]

HEALTHCHECK --interval=3s --timeout=10s --retries=10 \
  CMD redis-cli -a "${REDIS_AUTH:-myredissecret}" ping || exit 1

EXPOSE 6379
