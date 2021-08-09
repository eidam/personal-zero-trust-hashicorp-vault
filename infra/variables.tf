# GCP variables
variable "gcp_project_id" {
  description = "Google Cloud Platform (GCP) Project ID."
  type        = string
}

variable "gcp_zone" {
  description = "GCP region name."
  type        = string
}

variable "gcp_machine_type" {
  description = "GCP VM instance machine type."
  type        = string
}

variable "gcp_preemtible" {
  description = ""
  type        = bool
}

variable "gcp_automatic_restart" {
  description = ""
  type        = bool
}

# Cloudflare Variables
variable "cloudflare_account_id" {
  description = "The Cloudflare UUID for the Account the Zone lives in."
  type        = string
  sensitive   = true
}

variable "cloudflare_zone_name" {
  description = "The Cloudflare Zone to use."
  type        = string
}

variable "cloudflare_email" {
  description = "The Cloudflare user."
  type        = string
  sensitive   = true
}

variable "cloudflare_api_key" {
  description = "The Cloudflare user's API key."
  sensitive   = true
  type        = string
}

# Vault variables
variable "vault_subdomain" {
  description = "The Vault subdomain to use, -ssh will be also created."
  type        = string
}

variable "vault_subdomain_suffix_ssh" {
  description = "The Vault subdomain suffix to use for SSH web terminal"
  type        = string
}

variable "vault_subdomain_suffix_warp" {
  type = string
}

variable "vault_users" {
  description = ""
  type        = list(any)
  default     = []
}

variable "vault_ssh_users" {
  description = ""
  type        = list(any)
  default     = []
}

variable "vault_kms_auto_unseal" {
  description = ""
  type        = bool
}

variable "vault_kms_keyring_name" {
  description = ""
  type        = string
}

variable "vault_kms_keyring_location" {
  description = ""
  type        = string
}

variable "vault_gcs_bucket_name" {
  description = ""
  type        = string
}

variable "vault_gcs_location" {
  description = ""
  type        = string
}
