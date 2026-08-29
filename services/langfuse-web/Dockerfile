FROM docker.langfuse.com/langfuse/langfuse:4

# Langfuse web service - port 3000
# All env vars are set via Railway's variable system
# CMD is handled by the pre-built image's entrypoint

HEALTHCHECK --interval=10s --timeout=5s --retries=10 --start-period=30s \
  CMD curl -f http://localhost:3000/health || exit 1

EXPOSE 3000
