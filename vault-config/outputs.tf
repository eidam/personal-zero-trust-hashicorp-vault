locals {
  cloudflared_login_cmd = "cloudflared access login ${data.terraform_remote_state.infra.outputs.vault_endpoint}"
  cloudflared_token_cmd = "cloudflared access token -app=${data.terraform_remote_state.infra.outputs.vault_endpoint}"
  vault_login_cmd       = "VAULT_ADDR=${data.terraform_remote_state.infra.outputs.vault_endpoint_warp} vault write auth/jwt/login jwt=$(${local.cloudflared_token_cmd})"
}

output "cloudflared_login_cmd" {
  value = local.cloudflared_login_cmd
}

output "cloudflared_token_cmd" {
  value = local.cloudflared_token_cmd
}

output "vault_login_cmd" {
  value = local.vault_login_cmd
}
