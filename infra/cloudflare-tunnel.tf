data "cloudflare_zones" "zones" {
  filter {
    name        = var.cloudflare_zone_name
    lookup_type = "exact"
    status      = "active"
  }
}

locals {
  cloudflare_zone_id = lookup(element(data.cloudflare_zones.zones.zones, 0), "id")
}

# The random_id resource is used to generate a 35 character secret for the tunnel
resource "random_id" "tunnel_secret" {
  byte_length = 35
}

# A Named Tunnel resource called zero_trust_vault
resource "cloudflare_argo_tunnel" "vault" {
  account_id = var.cloudflare_account_id
  name       = "zero-trust-personal-vault"
  secret     = random_id.tunnel_secret.b64_std
}

# Reverse engineered API calls for "cloudflared tunnel list ip [add|get|delete]"
resource "restapi_object" "tunnel_route_ip" {
  object_id    = urlencode("${google_compute_instance.vault.network_interface.0.network_ip}/32")
  path         = ""
  read_path    = "/teamnet/routes/ip/${google_compute_instance.vault.network_interface.0.network_ip}"
  create_path  = "/teamnet/routes/network/{id}"
  destroy_path = "/teamnet/routes/network/{id}"

  read_search = {
    results_key = "result"
  }

  data = jsonencode({
    network   = "${google_compute_instance.vault.network_interface.0.network_ip}/32",
    tunnel_id = cloudflare_argo_tunnel.vault.id,
  })

  force_new = [
    "${google_compute_instance.vault.network_interface.0.network_ip}/32",
    cloudflare_argo_tunnel.vault.id
  ]
}
