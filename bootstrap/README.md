# Bootstrap (one-time)

This is the only manual step needed to get GitOps running on the local k3s cluster.

1. Set kubeconfig for k3s:
   - `export KUBECONFIG=/etc/rancher/k3s/k3s.yaml`
2. Create the Argo CD namespace:
   - `kubectl create namespace argocd`
3. Install Argo CD (pin a version you trust):
   - `kubectl apply -n argocd -f <ARGOCD_MANIFEST_URL>`
4. Apply the root application so Argo CD starts reconciling this repo:
   - `kubectl apply -n argocd -f clusters/k3s/root-app.yaml`

After this, all platform and app components should be managed by Argo CD.
