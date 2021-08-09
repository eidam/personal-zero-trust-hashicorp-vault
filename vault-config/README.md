# Vault configuration

## Unseal Vault 
For more info, refer to [official documentation](https://www.vaultproject.io/docs/concepts/seal)

You can use your Vault UI endpoint to walk you through the unseal process. 
**Store your unseal and root keys very carefully and securely!** 

You will need the root token for the initial Vault configuration, and then you can use just the Cloudflare Access JWTs to auth against Vault and get scoped token with TTL back.


## Terraform Configuration
1. Replace _(two occurrences!)_ `YOUR_CREATED_TF_STATE_BUCKET_NAME` in [providers.tf](./providers.tf)
2. Change required values in [vault.auto.tfvars](./vault.auto.tfvars)
    ```
    cloudflare_teams_name = "your-cloudflare-for-teams-team-name"

    # emails to assing admin policy to
    vault_admins = [
        "you@example.com
    ]
    ```
3. Optionally, adjust optional values in [vault.auto.tfvars](./vault.auto.tfvars)
4. Export Cloudflare credentials _(alternatively you will be asked to pass them in by Terraform on each command)_
    ```bash
    # vault root token
    export TF_VAR_VAULT_ROOT_TOKEN=
    ```

## Terraform Deployment
1. Run `terraform init`
2. Run `terraform apply` and confirm changes
    - Terraform will output commands for getting fresh Vault token using Cloudflare Access JWT auth
3. You are done and your Zero-Trust Vault is configured!

