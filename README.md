# Personal Zero-Trust HashiCorp Vault

Secrets are hard, especially for local development. This is why I took two of my favorite products 
([Cloudflare For Teams](https://www.cloudflare.com/teams/) and [HashiCorp Vault](https://www.vaultproject.io/))
and used them together to come up with a Zero-Trust deployment that is easy to use from any of my machines.

The focus was to achieve fast deployment and easy maintenance. Terraform takes care of the full deployment, and the full stack is deployed with two `terraform apply` commands. Everything is ready to go within minutes. 

## TLDR Stack 
- Terraform putting everything together ❤️
- Cloudflare for Teams
    - Cloudflare Tunnel
    - Cloudflare Access
        - Vault UI
        - Web Terminal SSH
        - JWT Auth backend
    - Cloudflare WARP to private network (through Tunnel)
- Google Cloud Platform
    - GCE Instance
    - GCS Bucket
    - Secret Manager
    - (optional) KMS

## Costs
### Cloudflare 
Free. _(for up to 50 users)_

### Google Cloud Platform
I cannot tell the exact GCP costs of this stack yet, but there is a Free Tier for the default machine type. 

If you want to change the region, just note that only some regions are eligible for the [GCP Free Tier](https://cloud.google.com/free/docs/gcp-free-tier). 

## Deployment 

The deployment process consists of two steps. The first one (Infra) is to deploy the Zero-Trust stack and the second one is configuring the Vault itself.

### 1. Pre-requisities
In order to deploy this stack, make sure you have:
- Terraform version 1.0+
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) setup and [authenticated](https://cloud.google.com/sdk/docs/authorizing) to a GCP project
    - Its recommended creating a new GCP project, with following APIs enabled
        - https://console.developers.google.com/apis/api/compute.googleapis.com/overview
        - https://console.developers.google.com/apis/api/secretmanager.googleapis.com/overview
        - _(optional - if auto-unseal is desired - **additional costs!**)_ https://console.developers.google.com/apis/api/cloudkms.googleapis.com/overview

- Google Storage Bucket for Terraform state
    - Manually create a GCS bucket in your GCP project, name it e.g. `tf-state-vault-my-project-id`
- Cloudflare Account with Cloudflare for Teams enabled

### 2. Infra
Please refer to [infra folder](./infra/)

### 3. Vault configuration
Please refer to [vault-config folder](./vault-config/)
