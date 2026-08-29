FROM langfuse/langfuse:3

# Langfuse web service - port 3000
# All env vars are set via Railway's variable system
# CMD is handled by the pre-built image's entrypoint
ARG CACHE_BUST=4

RUN echo "cache bust $(date)" > /tmp/cache-bust.txt

EXPOSE 3000