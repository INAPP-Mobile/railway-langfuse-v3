FROM docker.io/postgres:17-alpine

# pgvector is included in the 17-alpine image via apt, but we ensure it's available
RUN apk add --no-cache postgresql17-contrib

ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=postgres
ENV POSTGRES_DB=postgres
ENV TZ=UTC
ENV PGTZ=UTC

# Healthcheck
HEALTHCHECK --interval=3s --timeout=3s --retries=10 \
  CMD pg_isready -U postgres || exit 1

EXPOSE 5432

CMD ["postgres"]
