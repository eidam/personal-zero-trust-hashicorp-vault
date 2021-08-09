terraform {
  backend "gcs" {
    bucket = "YOUR_CREATED_TF_STATE_BUCKET_NAME"
    prefix = "terraform/vault-config"
  }
}

# this is data resource for fetching state from the infra Terraform folder
data "terraform_remote_state" "infra" {
  backend = "gcs"
  config = {
    bucket = "YOUR_CREATED_TF_STATE_BUCKET_NAME"
    prefix = "terraform/infra"
  }
}

provider "vault" {
  address = data.terraform_remote_state.infra.outputs.vault_endpoint_warp
  token   = var.VAULT_ROOT_TOKEN
}
