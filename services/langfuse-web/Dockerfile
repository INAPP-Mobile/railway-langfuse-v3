FROM langfuse/langfuse:3

# Langfuse web service - port 3000.
# Wrap the base image's entrypoint with an ENCRYPTION_KEY compatibility
# shim (stretches 32-char keys to 64-hex deterministically; 64-hex keys
# pass through unchanged). Preserves base ENTRYPOINT and CMD exactly.
COPY entrypoint-shim.sh /usr/local/bin/entrypoint-shim
RUN chmod +x /usr/local/bin/entrypoint-shim

USER nextjs
ENTRYPOINT ["dumb-init", "--", "/usr/local/bin/entrypoint-shim", "./web/entrypoint.sh"]
CMD ["/bin/sh", "-c", "node ./web/server.js --keepAliveTimeout 110000"]

ARG CACHE_BUST=8
RUN echo "cache bust $(date)" > /tmp/cache-bust.txt

EXPOSE 3000
