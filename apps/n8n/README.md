# n8n (Docker image deployment)

This app is deployed from a Docker image (not a Helm chart).

## Image choice
- Default: `n8nio/n8n:latest`
- If you prefer to build your own image, push it to your registry and update
  `apps/n8n/deployment.yaml`.

## Required secrets (Doppler)
`apps/n8n/external-secret.yaml` expects these keys:
- `N8N_ENCRYPTION_KEY`
- `N8N_HOST`
- `N8N_PROTOCOL`
- `N8N_WEBHOOK_URL`
- `N8N_BASIC_AUTH_USER`
- `N8N_BASIC_AUTH_PASSWORD`
- `N8N_DB_USER`
- `N8N_DB_PASSWORD`

## Required config
Update these placeholders in `apps/n8n/configmap.yaml`:
- `DB_POSTGRESDB_HOST`, `DB_POSTGRESDB_DATABASE`

## Postgres
PostgreSQL is deployed alongside n8n using a StatefulSet in this same folder.
The Postgres credentials are sourced from Doppler keys `N8N_DB_USER` and
`N8N_DB_PASSWORD` via `apps/n8n/postgres-external-secret.yaml`.
