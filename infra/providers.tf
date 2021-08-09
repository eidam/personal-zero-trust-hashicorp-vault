terraform {
  backend "gcs" {
    bucket = "YOUR_CREATED_TF_STATE_BUCKET_NAME"
    prefix = "terraform/infra"
  }

  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
    google = {
      source = "hashicorp/google"
    }
    random = {
      source = "hashicorp/random"
    }
    template = {
      source = "hashicorp/template"
    }
    restapi = {
      source = "fmontezuma/restapi"
    }
  }
  required_version = ">= 1.0"
}

# Providers
provider "cloudflare" {
  account_id = var.cloudflare_account_id
  email      = var.cloudflare_email
  api_key    = var.cloudflare_api_key
}

provider "google" {
  project = var.gcp_project_id
}

provider "random" {}

// Cloudflare for Teams REST
provider "restapi" {
  # Configuration options
  uri = "https://api.cloudflare.com/client/v4/accounts/${var.cloudflare_account_id}"

  headers = {
    "X-Auth-Email" : var.cloudflare_email,
    "X-Auth-Key" : var.cloudflare_api_key,
  }
}
