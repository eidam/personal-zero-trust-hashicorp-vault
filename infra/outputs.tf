output "vault_endpoint" {
  value = "https://${cloudflare_record.vault.hostname}"
}

output "vault_endpoint_ssh" {
  value = "https://${cloudflare_record.vault_ssh.hostname}"
}

output "vault_endpoint_warp" {
  value = "http://${cloudflare_record.vault_warp.hostname}:8200"
}

output "access_vault_jwt_aud" {
  value = cloudflare_access_application.vault.aud
}
