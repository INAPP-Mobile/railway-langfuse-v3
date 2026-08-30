FROM langfuse/langfuse-worker:3

# Dedicated Langfuse worker image - base entrypoint wrapped with the
# ENCRYPTION_KEY compatibility shim (see web Dockerfile). Worker is
# internal-only; Railway does not healthcheck it.
USER root
COPY --chmod=0755 entrypoint-shim.sh /usr/local/bin/entrypoint-shim

USER expressjs
ENTRYPOINT ["dumb-init", "--", "/usr/local/bin/entrypoint-shim", "./worker/entrypoint.sh"]
CMD ["node", "worker/dist/index.js"]

ENV PORT=3030
ARG CACHE_BUST=9
RUN echo "cache bust $(date)" > /tmp/cache-bust.txt

EXPOSE 3030
