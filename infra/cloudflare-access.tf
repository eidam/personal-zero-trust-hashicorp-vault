locals {
  vault_users     = length(var.vault_users) > 0 ? var.vault_users : [var.cloudflare_email]
  vault_ssh_users = length(var.vault_ssh_users) > 0 ? var.vault_ssh_users : [var.cloudflare_email]
}

# Access application to apply zero trust policy to Vault/SSH
resource "cloudflare_access_application" "vault" {
  zone_id          = local.cloudflare_zone_id
  name             = "${var.vault_subdomain}.${var.cloudflare_zone_name}"
  domain           = "${var.vault_subdomain}.${var.cloudflare_zone_name}"
  session_duration = "1h"
  type             = "self_hosted"
}

# Access policy that the above appplication uses. (i.e. who is allowed in)
resource "cloudflare_access_policy" "vault" {
  application_id = cloudflare_access_application.vault.id
  zone_id        = local.cloudflare_zone_id
  name           = cloudflare_access_application.vault.domain
  precedence     = "1"
  decision       = "allow"

  include {
    email = local.vault_users
  }
}

# Access application to apply zero trust policy to Vault/SSH
resource "cloudflare_access_application" "vault_ssh" {
  zone_id          = local.cloudflare_zone_id
  name             = "${var.vault_subdomain}${var.vault_subdomain_suffix_ssh}.${var.cloudflare_zone_name}"
  domain           = "${var.vault_subdomain}${var.vault_subdomain_suffix_ssh}.${var.cloudflare_zone_name}"
  session_duration = "1h"
  type             = "ssh"
}

# Access policy that the above appplication uses. (i.e. who is allowed in)
resource "cloudflare_access_policy" "vault_ssh" {
  application_id = cloudflare_access_application.vault_ssh.id
  zone_id        = local.cloudflare_zone_id
  name           = cloudflare_access_application.vault_ssh.domain
  precedence     = "1"
  decision       = "allow"

  include {
    email = local.vault_ssh_users
  }
}

# SSH CA certificate for SSH short-lived certificates
resource "cloudflare_access_ca_certificate" "vault_ssh" {
  zone_id        = local.cloudflare_zone_id
  application_id = cloudflare_access_application.vault_ssh.id
}
