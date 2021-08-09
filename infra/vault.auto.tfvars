####
## REQUIRED
####
gcp_project_id = ""

cloudflare_account_id = ""
cloudflare_zone_name  = ""

####
## OPTIONAL (with defaults)
####
gcp_zone              = "us-east1-b"
gcp_machine_type      = "e2-micro"
gcp_preemtible        = false
gcp_automatic_restart = true

# DNS records for Cloudflare Access Application and Cloudflare DNS
vault_subdomain             = "vault"
vault_subdomain_suffix_ssh  = "-ssh"
vault_subdomain_suffix_warp = "-warp"

vault_users = [
  # list of strings of emails to grant access to Vault UI, defaults to TF_VAR_cloudflare_email
]

vault_ssh_users = [
  # list of strings of emails to grant access to Vault instance SSH (sudoers), defaults to TF_VAR_cloudflare_email
]

vault_kms_auto_unseal      = false
vault_kms_keyring_name     = "vault-auto-unseal"
vault_kms_keyring_location = "global"
vault_gcs_bucket_name      = "vault-storage-backend"
# if empty, vault_gcs_location is inherited from the gcp_zone (US/EU/ASIA)
vault_gcs_location = ""
