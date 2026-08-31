# Deploy and Host Langfuse

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.com/deploy/pudIOo)

Langfuse is an open-source LLM observability platform — the self-hosted alternative to LangSmith. It gives you tracing, metrics, evals, and prompt management for your LLM applications in one place.

## About Hosting

This template deploys the production Langfuse v3 stack on Railway as a 6-service application:

| Service | Purpose |
|---------|---------|
| langfuse-web | Next.js app server (frontend + API), port 3000 |
| langfuse-worker | Background job processor |
| postgres | Primary database (`postgres:17` with pgvector) |
| clickhouse | Analytics database for event traces |
| redis | Cache + BullMQ job queue |
| minio | S3-compatible object storage for media and batch exports |

## Why Deploy

- **One-click setup** — every credential (Postgres, Redis, ClickHouse, MinIO, encryption keys) is auto-generated on first deploy.
- **Zero config** — services are wired together with Railway companion references; no manual URL or password plumbing.
- **Production-shaped** — persistent volumes on all stateful services, so your data survives redeploys.
- **Cost-effective** — a full LLM observability stack for roughly $8.50/mo on Railway's Hobby plan.

## Common Use Cases

- Tracing and debugging LLM agent/production calls (OpenAI, Anthropic, and any Langfuse SDK).
- Building evaluation pipelines over real production traces.
- Prompt versioning and management.
- Self-hosting your observability data instead of sending it to a SaaS vendor.

## Dependencies

This template provisions its own Postgres, ClickHouse, Redis, and MinIO — no external services required.

## Configuration

All environment variables are managed by Railway. On first deploy:

1. `ENCRYPTION_KEY` is auto-generated (64-char hex)
2. `NEXTAUTH_SECRET` and `SALT` are auto-generated
3. Database credentials are auto-generated per service
4. Redis password is auto-generated

## After Deploy

1. Open the web app at your Railway public domain.
2. Create your first organization and project.
3. Use the generated API keys to integrate Langfuse with your LLM applications.

## Storage

- **Postgres**: Persistent volume at `/var/lib/postgresql/data`
- **ClickHouse**: Persistent volume at `/var/lib/clickhouse`
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
