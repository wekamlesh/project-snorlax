# Backup and Restore Drill (Velero + R2)

This runbook validates that backups and restores work after a VM reset or app failure.

## Preconditions
- k3s cluster is running.
- Velero is installed and connected to R2.
- External Secrets Operator is syncing the `velero-credentials` secret.

## Backup Drill
1. Create a manual backup:
   - `velero backup create manual-$(date +%Y%m%d-%H%M) --include-namespaces n8n,observability`
2. Check backup status:
   - `velero backup get`
   - `velero backup describe <backup-name>`
3. (Postgres) Verify the `postgres-data` PVC is included in the backup and restic snapshots exist.

## Restore Drill
1. Simulate failure:
   - `kubectl delete namespace n8n`
2. Restore the namespace:
   - `velero restore create --from-backup <backup-name>`
3. Verify workloads:
   - `kubectl get pods -n n8n`
   - `kubectl get ingress -n n8n`
4. (Postgres) Confirm the Postgres pod starts and n8n can connect.

## Full VM Reset (High-level)
1. Reinstall Debian 13 and k3s.
2. Bootstrap Argo CD and point it to this repo.
3. Create the Doppler bootstrap token secret in `external-secrets`.
4. Wait for Argo CD to reconcile.
5. Run a Velero restore from the latest backup.
6. Validate Postgres + n8n connectivity.

## Notes
- For PostgreSQL, add a separate DB dump/restore job and verify it in this drill.
