# Infrastructure provisioning

## Configuration
1. Change required values in [vault.auto.tfvars](./vault.auto.tfvars)
    ```
    gcp_project_id = "your-project-id"

    cloudflare_account_id = "xxxyyy"
    cloudflare_zone_name  = "example.com"
    ```
2. Optionally, adjust optional ones
3. Export Cloudflare credentials _(alternatively you will be asked to pass them in by Terraform on each command)_
    ```bash
    export TF_VAR_cloudflare_email=
    # API key is your Global API key
    export TF_VAR_cloudflare_api_key=
    ```
4. Run `terraform init`
5. Run `terraform apply` and confirm changes
    - Terraform will output your endpoints at the end
6. Wait, it takes ~10 minutes to fully spin up, endpoints should come up online in the following order:
    - SSH Web Terminal
    - Vault UI
    - Vault WARP
7. You are done and your Zero-Trust Vault is up and running
8. Continue to [configuring the Vault](../vault-config/) itself 
