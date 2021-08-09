resource "google_secret_manager_secret" "cloudflare_tunnel_credentials" {
  secret_id = "cloudflare-tunnel-credentials"

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_iam_binding" "vault_instance" {
  project   = google_secret_manager_secret.cloudflare_tunnel_credentials.project
  secret_id = google_secret_manager_secret.cloudflare_tunnel_credentials.secret_id
  role      = "roles/secretmanager.secretAccessor"
  members = [
    "serviceAccount:${google_service_account.vault_instance.email}",
  ]
}

resource "google_secret_manager_secret_version" "cloudflare_tunnel_credentials" {
  secret = google_secret_manager_secret.cloudflare_tunnel_credentials.id

  secret_data = <<EOT
{
    "AccountTag"   : "${var.cloudflare_account_id}",
    "TunnelID"     : "${cloudflare_argo_tunnel.vault.id}",
    "TunnelName"   : "${cloudflare_argo_tunnel.vault.name}",
    "TunnelSecret" : "${random_id.tunnel_secret.b64_std}"
}
EOT
}
