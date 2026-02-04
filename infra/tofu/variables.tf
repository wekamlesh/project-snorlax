variable "cloudflare_api_token" {
  type      = string
  sensitive = true
}

variable "cloudflare_account_id" {
  type = string
}

variable "cloudflare_zone_id" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "subdomains" {
  type = list(string)
}

variable "vm_ipv4" {
  type = string
}

variable "vm_ipv6" {
  type    = string
  default = ""
}

variable "cloudflare_proxied" {
  type    = bool
  default = true
}

variable "manage_velero_bucket" {
  type    = bool
  default = false
}

variable "velero_bucket_name" {
  type    = string
  default = "snorlax-velero-backups"
}

variable "manage_state_bucket" {
  type    = bool
  default = false
}

variable "state_bucket_name" {
  type    = string
  default = "snorlax-tofu-state"
}
