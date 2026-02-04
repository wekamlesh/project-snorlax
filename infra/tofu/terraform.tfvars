cloudflare_api_token  = "0fKl8VnMWGJXp2aCo0Qhrd7Qekv_uMoKL-FVZm5z"
cloudflare_account_id = "c03dbc6f7e1be2187be646fd35be1ea2"
cloudflare_zone_id    = "2f09e3dc8a21efb840cbd4f3cb3f2f01"

domain_name = "kamleshmerugu.me"
subdomains  = ["n8n", "grafana", "argocd", "headlamp"]

vm_ipv4 = "38.242.134.151"
vm_ipv6 = ""

cloudflare_proxied = true

# Set to true only after you have bootstrapped the backend (see README).
manage_velero_bucket = false
velero_bucket_name   = "snorlax-velero-backups"

manage_state_bucket = false
state_bucket_name   = "snorlax-tofu-state"
