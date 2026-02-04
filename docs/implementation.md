# Implementation Guide (k3s + Argo CD + NGINX + ESO + Velero)

This guide walks you through a clean, repeatable setup.

## 0) Decide how to handle hostnames + ACME email
Kubernetes needs real values for Ingress hosts and the ACME email. Pick one:

1. Commit hostnames + email to Git (simplest and standard GitOps).
2. Encrypt them in Git (SOPS/KSOPS).
3. Manual overlay (keep placeholders in Git, patch the cluster manually).

If you choose option 3, you must add a manual step after Argo sync to patch hostnames/email.

## 1) OpenTofu: Cloudflare DNS + R2 backend
1. Copy `infra/tofu/terraform.tfvars.example` to `infra/tofu/terraform.tfvars`.
2. Fill values (Cloudflare account/zone/token, domain, subdomains, VM IP).
3. Create the state bucket (one-time):
   - `tofu init -backend=false`
   - set `manage_state_bucket = true`
   - `tofu apply`
4. Switch to R2 backend:
   - set `manage_state_bucket = false`
   - `tofu init -migrate-state`
5. Apply DNS records:
   - `tofu plan`
   - `tofu apply`

## 2) Install k3s on Debian 13
1. Install k3s (disable Traefik because NGINX will handle ingress):
   - `curl -sfL https://get.k3s.io | sh -s - --disable traefik`
2. Export kubeconfig:
   - `export KUBECONFIG=/etc/rancher/k3s/k3s.yaml`
3. Verify node:
   - `kubectl get nodes`

## 3) Install Argo CD
1. Create namespace:
   - `kubectl create namespace argocd`
2. Install Argo CD (pin a version you trust):
   - `kubectl apply -n argocd -f <ARGOCD_MANIFEST_URL>`
3. Apply the root application:
   - `kubectl apply -n argocd -f clusters/k3s/root-app.yaml`

### If the Git repo is private (PAT setup)
If your repo is private, Argo CD needs credentials.

1. Create a GitHub Personal Access Token (fine-grained), with:
   - Repository access: only this repo
   - Permissions: Contents read
2. Create the repo secret in Argo CD:
   - `kubectl -n argocd create secret generic repo-project-snorlax \\
     --from-literal=url=https://github.com/wekamlesh/project-snorlax.git \\
     --from-literal=username=wekamlesh \\
     --from-literal=password=YOUR_GITHUB_PAT \\
     --from-literal=type=git \\
     --dry-run=client -o yaml | kubectl apply -f -`
3. Label the secret so Argo CD recognizes it:
   - `kubectl -n argocd label secret repo-project-snorlax argocd.argoproj.io/secret-type=repository`
4. Force refresh:
   - `kubectl -n argocd annotate application root argocd.argoproj.io/refresh=hard --overwrite`

## 4) Bootstrap External Secrets (Doppler)
1. Create Doppler service token in project `snorlax`, config `prd`.
2. Add it to the cluster (one-time bootstrap):
   - `kubectl -n external-secrets create secret generic doppler-token --from-literal=dopplerToken=...`
3. Argo CD will apply `ClusterSecretStore` and start syncing.

## 5) Configure required secrets in Doppler
These keys are required:
- `CLOUDFLARE_API_TOKEN`
- `R2_ACCESS_KEY_ID`
- `R2_SECRET_ACCESS_KEY`
- `N8N_ENCRYPTION_KEY`
- `N8N_BASIC_AUTH_USER`
- `N8N_BASIC_AUTH_PASSWORD`
- `N8N_DB_USER`
- `N8N_DB_PASSWORD`
- `N8N_HOST`
- `N8N_PROTOCOL`
- `N8N_WEBHOOK_URL`

## 6) Fill hostnames + ACME email
- `platform/cert-manager/config/cluster-issuer.yaml` (email)
- `apps/n8n/ingress.yaml` (n8n host + TLS secret)
- `clusters/k3s/apps/platform-observability.yaml` (Grafana host + TLS)

If you picked manual overlays, patch these after Argo sync.

## 7) Verify platform namespaces
Argo will create and deploy to these namespaces:
- `nginx-ingress`
- `cert-manager`
- `external-secrets`
- `velero`
- `observability`
- `n8n`

Argo CD itself stays in `argocd` (only the controller + Application CRs).

## 8) Validate ingress + TLS
1. Check NGINX ingress controller:
   - `kubectl get pods -n nginx-ingress`
2. Check cert-manager:
   - `kubectl get certificates -A`
3. Verify DNS resolves to your VM IPs.

## 9) Validate n8n + Postgres
1. Check pods:
   - `kubectl get pods -n n8n`
2. Confirm n8n can connect to Postgres.

## 10) Backup and restore drill
Follow `runbooks/backup-restore.md`.
