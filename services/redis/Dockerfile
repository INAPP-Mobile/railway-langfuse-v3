FROM docker.io/redis:7-alpine

# Require password and disable eviction for BullMQ.
# NOTE: exec-form CMD does NOT expand ${VAR} — must use shell form so
# REDIS_AUTH (injected at runtime) is expanded before exec.
CMD redis-server --requirepass "$REDIS_AUTH" --maxmemory-policy noeviction

HEALTHCHECK --interval=3s --timeout=10s --retries=10 \
  CMD redis-cli -a "$REDIS_AUTH" ping || exit 1

EXPOSE 6379