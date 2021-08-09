# Infrastructure provisioning

## Cloudflare WARP configuration
In order to access Vault over private network you need to have WARP client installed and configured for your Cloudflare for Teams account.

Make sure to [Route private 10.0.0.0/8 range through WARP](https://developers.cloudflare.com/cloudflare-one/tutorials/warp-to-tunnel#route-private-ip-ranges-through-warp):
1. Make sure HTTP traffic filtering is enabled. This lets Cloudflare proxy your private IP ranges to corresponding Cloudflare Tunnels.
2. Find `10.0.0.0/8` in Split Tunnels entries and delete it

## Terraform Configuration
1. Replace `YOUR_CREATED_TF_STATE_BUCKET_NAME` in [providers.tf](./providers.tf)
2. Change required values in [vault.auto.tfvars](./vault.auto.tfvars)
    ```
    gcp_project_id = "your-project-id"

    cloudflare_account_id = "xxxyyy"
    cloudflare_zone_name  = "example.com"
    ```
3. Optionally, adjust optional values in [vault.auto.tfvars](./vault.auto.tfvars)
4. Export Vault root token _(alternatively you will be asked to pass it in by Terraform on each command)_
    ```bash
    export TF_VAR_cloudflare_email=
    # API key is your Global API key
    export TF_VAR_cloudflare_api_key=
    ```

## Terraform Deployment
1. Run `terraform init`
2. Run `terraform apply` and confirm changes
    - Terraform will output your endpoints at the end
3. Wait, it takes ~10 minutes to fully spin up, endpoints should come up online in the following order:
    - SSH Web Terminal
    - Vault UI
    - Vault WARP
4. You are done and your Zero-Trust Vault is up and running
5. Continue to [configuring the Vault](../vault-config/) itself 
