# Create DNS records after Access Application is created (forced by referencing Application domain)
resource "cloudflare_record" "vault" {
  zone_id = local.cloudflare_zone_id
  name    = cloudflare_access_application.vault.domain
  value   = "${cloudflare_argo_tunnel.vault.id}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
}

resource "cloudflare_record" "vault_ssh" {
  zone_id = local.cloudflare_zone_id
  name    = cloudflare_access_application.vault_ssh.domain
  value   = "${cloudflare_argo_tunnel.vault.id}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
}

resource "cloudflare_record" "vault_warp" {
  zone_id = local.cloudflare_zone_id
  name    = "${var.vault_subdomain}${var.vault_subdomain_suffix_warp}"
  value   = google_compute_instance.vault.network_interface.0.network_ip
  type    = "A"
  proxied = false
}
