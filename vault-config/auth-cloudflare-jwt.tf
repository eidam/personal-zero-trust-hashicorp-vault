resource "vault_jwt_auth_backend" "access_jwt" {
  description  = "Demonstration of the Workers Cloudflare Accesss auth backend"
  type         = "jwt"
  path         = "jwt"
  bound_issuer = "https://${var.cloudflare_teams_name}.cloudflareaccess.com"
  jwks_url     = "https://${var.cloudflare_teams_name}.cloudflareaccess.com/cdn-cgi/access/certs"

  default_role = "default"
}

resource "vault_jwt_auth_backend_role" "default" {
  backend         = vault_jwt_auth_backend.access_jwt.path
  role_type       = "jwt"
  role_name       = "default"
  bound_audiences = [data.terraform_remote_state.infra.outputs.access_vault_jwt_aud]
  user_claim      = "email"

  bound_claims = {
    "iss" = "https://${var.cloudflare_teams_name}.cloudflareaccess.com"
  }

  token_policies = ["default"]
  token_ttl      = var.vault_token_ttl
  token_max_ttl  = var.vault_token_ttl

  claim_mappings = {
    email = "email"
  }
}

resource "vault_identity_entity" "vault_admin" {
  name     = "vault-admin"
  policies = ["vault-admin"]
}

resource "vault_identity_entity_alias" "vault_admin" {
  for_each       = toset(var.vault_admins)
  name           = each.key
  mount_accessor = vault_jwt_auth_backend.access_jwt.accessor
  canonical_id   = vault_identity_entity.vault_admin.id
}
