FROM langfuse/langfuse-worker:3

# Dedicated Langfuse worker image - base entrypoint runs
# node /app/worker/index.js; wrapped with ENCRYPTION_KEY compatibility
# shim (stretches 32-char keys to 64-hex deterministically; 64-hex keys
# pass through unchanged). Worker is internal-only (no public domain);
# Railway does not healthcheck it.
COPY entrypoint-shim.sh /usr/local/bin/entrypoint-shim
RUN chmod +x /usr/local/bin/entrypoint-shim

USER expressjs
ENTRYPOINT ["dumb-init", "--", "/usr/local/bin/entrypoint-shim", "./worker/entrypoint.sh"]
CMD ["node", "worker/dist/index.js"]

ENV PORT=3030
ARG CACHE_BUST=8
RUN echo "cache bust $(date)" > /tmp/cache-bust.txt

EXPOSE 3030