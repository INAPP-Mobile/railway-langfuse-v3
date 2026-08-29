FROM docker.io/pgvector/pgvector:pg17

# POSTGRES_PASSWORD is injected by Railway at runtime via ${{secret(32)}}
ENV POSTGRES_USER=postgres
ENV POSTGRES_DB=postgres
ENV TZ=UTC
ENV PGTZ=UTC

# Healthcheck
HEALTHCHECK --interval=3s --timeout=3s --retries=10 \
  CMD pg_isready -U postgres || exit 1

EXPOSE 5432

CMD ["postgres"]
