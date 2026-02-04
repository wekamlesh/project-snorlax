# Doppler bootstrap token

External Secrets Operator needs a Doppler service token to start syncing secrets.
Create the token in Doppler and add it as a Kubernetes Secret in the
`external-secrets` namespace before syncing the config.

Example (manual bootstrap):
- `kubectl -n external-secrets create secret generic doppler-token --from-literal=dopplerToken=...`

This is a one-time bootstrap secret. Keep it out of Git.

## Doppler keys used by apps
`apps/n8n/external-secret.yaml` expects these keys in Doppler:
- `N8N_ENCRYPTION_KEY`
- `N8N_HOST`
- `N8N_PROTOCOL`
- `N8N_WEBHOOK_URL`
- `N8N_BASIC_AUTH_USER`
- `N8N_BASIC_AUTH_PASSWORD`
- `N8N_DB_USER`
- `N8N_DB_PASSWORD`
