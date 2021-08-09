variable "VAULT_ROOT_TOKEN" {
  sensitive = true
}

variable "cloudflare_teams_name" {
  type = string
}

variable "vault_token_ttl" {
  type = number
}

variable "vault_admins" {
  type = list(any)
}
