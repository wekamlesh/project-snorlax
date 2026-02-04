locals {
  subdomain_map = { for s in var.subdomains : s => s }
}

resource "cloudflare_r2_bucket" "velero" {
  count      = var.manage_velero_bucket ? 1 : 0
  account_id = var.cloudflare_account_id
  name       = var.velero_bucket_name
}

resource "cloudflare_r2_bucket" "state" {
  count      = var.manage_state_bucket ? 1 : 0
  account_id = var.cloudflare_account_id
  name       = var.state_bucket_name
}

resource "cloudflare_record" "app_a" {
  for_each = local.subdomain_map

  zone_id = var.cloudflare_zone_id
  name    = each.value
  type    = "A"
  value   = var.vm_ipv4
  proxied = var.cloudflare_proxied
  ttl     = 1
}

resource "cloudflare_record" "app_aaaa" {
  for_each = var.vm_ipv6 == "" ? {} : local.subdomain_map

  zone_id = var.cloudflare_zone_id
  name    = each.value
  type    = "AAAA"
  value   = var.vm_ipv6
  proxied = var.cloudflare_proxied
  ttl     = 1
}

output "app_fqdns" {
  value = [for s in var.subdomains : "${s}.${var.domain_name}"]
}
