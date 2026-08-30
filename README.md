# Langfuse v3 — LLM observability platform
#
# Deploy a production-ready Langfuse v3 stack on Railway with:
# - langfuse-web (Next.js frontend + API)
# - langfuse-worker (background job processor)
# - postgres (with pgvector)
# - clickhouse (analytics database)
# - redis (caching + BullMQ queue)
# - minio (S3-compatible object storage)
#
# All secrets are auto-generated on first deploy.
# Only langfuse-web (port 3000) is exposed publicly.

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.com/deploy/JvyW_g)

## Services

| Service | Image | Port | Public |
|---------|-------|------|--------|
| langfuse-web | docker.langfuse.com/langfuse/langfuse:4 | 3000 | Yes |
| langfuse-worker | docker.langfuse.com/langfuse/langfuse-worker:4 | 3030 | No |
| postgres | postgres:17-alpine | 5432 | No |
| clickhouse | clickhouse/clickhouse-server:25.12 | 8123 | No |
| redis | redis:7-alpine | 6379 | No |
| minio | cgr.dev/chainguard/minio | 9000 | No |

## Configuration

All environment variables are managed by Railway. On first deploy:

1. `ENCRYPTION_KEY` is auto-generated (64-char hex)
2. `NEXTAUTH_SECRET` is auto-generated
3. `SALT` is auto-generated
4. Database credentials are auto-generated
5. Redis password is auto-generated

## After Deploy

1. Visit your public URL (e.g., `https://your-app.up.railway.app`)
2. Create your first organization and project
3. Use the generated API keys to integrate Langfuse with your LLM applications

## Storage

- **Postgres**: Persistent volume at `/var/lib/postgresql/data`
- **ClickHouse**: Persistent volumes at `/var/lib/clickhouse` and `/var/log/clickhouse-server`
- **Redis**: Persistent volume at `/data`
- **MinIO**: Persistent volume at `/data`

## Resource Estimates

| Service | Memory | Cost/mo |
|---------|--------|---------|
| langfuse-web | 512 MB | ~$2 |
| langfuse-worker | 512 MB | ~$2 |
| postgres | 256 MB | ~$1 |
| clickhouse | 512 MB | ~$2 |
| redis | 128 MB | ~$0.50 |
| minio | 256 MB | ~$1 |
| **Total** | **~2.2 GB** | **~$8.50** |

## Updating

To update Langfuse, redeploy with the new image tag. Database migrations run automatically on startup.

## License

Langfuse is MIT-licensed. See https://github.com/langfuse/langfuse for details.
