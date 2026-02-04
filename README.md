# Project Snorlax: k3s + GitOps + Backups

This repo bootstraps a single-node k3s cluster with Argo CD, NGINX Ingress Controller, External Secrets Operator (Doppler), cert-manager, Velero to Cloudflare R2, and observability.

## Repo Layout
- `infra/tofu`: OpenTofu for Cloudflare DNS + R2 backend
- `bootstrap`: one-time Argo CD bootstrap steps
- `clusters/k3s`: Argo CD root app and app definitions
- `platform`: platform configs (External Secrets, cert-manager, Velero)
- `apps`: app definitions (n8n and others)
- `runbooks`: backup/restore drills
- `docs`: implementation guide

## Quick Start (high level)
1. Configure Cloudflare via OpenTofu in `infra/tofu`.
2. Install k3s on Debian 13 (disable Traefik so NGINX can own ingress).
3. Bootstrap Argo CD using `bootstrap/README.md`.
4. Review pinned chart versions in `clusters/k3s/apps`.
5. Add Doppler token secret to `external-secrets` namespace.
6. Verify certificates and ingress per app.

For step-by-step instructions, see `docs/implementation.md`.

## Pinned chart versions (as of 2026-02-04)
- nginx-ingress: 2.4.2
- cert-manager: 1.19.2
- external-secrets: 1.3.2
- velero: 11.1.1
- kube-prometheus-stack: 80.13.3
- loki: 6.49.0
## App images
- n8n: `n8nio/n8n:latest` (image tag is intentionally latest)

## Placeholders to Replace
Search for these tokens and replace them:
- `example.com` and example hostnames

## Privacy note
If you don't want hostnames or ACME email in Git, we need a render-time injection
strategy (for example, Argo CD config-management plugins or encrypted manifests).
Call this out and we can wire the approach you prefer.

## Kubeconfig file
Local k3s kubeconfig path:
- `/etc/rancher/k3s/k3s.yaml`
