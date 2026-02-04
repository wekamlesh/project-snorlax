# OpenTofu: Cloudflare DNS + R2

This folder manages Cloudflare DNS records for app subdomains and optionally the R2 buckets used by Velero and OpenTofu state.

## Backend (R2)
This configuration uses an S3 backend pointing at Cloudflare R2. The backend is defined in `backend.tf`
and currently points to the `snorlax-tofu-state` bucket.

Environment variables required for `tofu init` and `tofu plan/apply`:
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_REGION` (use `auto` for R2)

## Bootstrap flow (one-time)
OpenTofu cannot create the backend bucket before it exists. Use this flow once:

1. Temporarily disable the backend and create the bucket:
   - `tofu init -backend=false`
   - Set `manage_state_bucket = true` in `terraform.tfvars`
   - `tofu apply`
2. Re-enable the backend in `backend.tf` and migrate state:
   - `tofu init -migrate-state`
   - Set `manage_state_bucket = false` (optional, to avoid managing it)

If you prefer, create the R2 bucket manually in Cloudflare and skip step 1.

If you also want OpenTofu to manage the Velero bucket, set `manage_velero_bucket = true`
after the backend is initialized.

## Usage
1. Copy `terraform.tfvars.example` to `terraform.tfvars` and fill in values.
2. `tofu init`
3. `tofu plan`
4. `tofu apply`

## Notes
- Records are created as per-subdomain `A` records, plus optional `AAAA` if `vm_ipv6` is set.
- `cloudflare_proxied = true` keeps traffic behind Cloudflare.
