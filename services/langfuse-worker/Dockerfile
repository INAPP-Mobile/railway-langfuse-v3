FROM langfuse/langfuse-worker:3

# Dedicated Langfuse worker image - has its own entrypoint that runs
# node /app/worker/index.js; no CMD override needed.
# Worker is internal-only (no public domain); Railway does not healthcheck it.
ARG CACHE_BUST=4

ENV PORT=3030

EXPOSE 3030