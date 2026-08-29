FROM docker.langfuse.com/langfuse/langfuse:4

# Langfuse web service - port 3000
# All env vars are set via Railway's variable system
# CMD is handled by the pre-built image's entrypoint
# Disable inherited HEALTHCHECK - Railway uses TCP healthcheck on port 3000
ARG CACHE_BUST=3
HEALTHCHECK NONE

# Force new layer to bust cache
RUN echo "cache bust $(date)" > /tmp/cache-bust.txt

EXPOSE 3000
