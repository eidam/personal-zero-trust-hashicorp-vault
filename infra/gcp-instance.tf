# OS the server will use
data "google_compute_image" "image" {
  family  = "ubuntu-minimal-2004-lts"
  project = "ubuntu-os-cloud"
}

resource "google_service_account" "vault_instance" {
  account_id   = "vault-instance"
  display_name = "Vault Instance Service Account"
}

# GCP Instance resource
resource "google_compute_instance" "vault" {
  name         = "vault"
  machine_type = var.gcp_machine_type
  zone         = var.gcp_zone

  // Your tags may differ. This one instructs the networking to not allow access to port 22
  tags = ["no-ssh"]

  boot_disk {
    initialize_params {
      image = data.google_compute_image.image.self_link
    }
  }

  network_interface {
    network = "default"
    access_config {
      // Ephemeral IP
    }
  }

  // Optional config to make instance ephemeral 
  scheduling {
    preemptible       = var.gcp_preemtible
    automatic_restart = var.gcp_automatic_restart
  }

  allow_stopping_for_update = true

  // This is where we configure the server (aka instance). 
  // We need to template Cloudflare Tunnel ID only, as credentials file is fetched from Secrets Manager.
  metadata_startup_script = templatefile(
    "./templates/gcp-instance-startup-script.sh",
    {
      gcp_project_id        = var.gcp_project_id
      cf_tunnel_id          = cloudflare_argo_tunnel.vault.id,
      vault_gcs_bucket_name = google_storage_bucket.vault_storage_backend.name
      vault_hostname        = "${var.vault_subdomain}.${var.cloudflare_zone_name}"
      vault_ssh_hostname    = "${var.vault_subdomain}${var.vault_subdomain_suffix_ssh}.${var.cloudflare_zone_name}"
      vault_ssh_users       = local.vault_ssh_users
      vault_ssh_ca_key      = cloudflare_access_ca_certificate.vault_ssh.public_key

      # if KMS auto-unseal is enabled
      vault_kms_auto_unseal      = var.vault_kms_auto_unseal
      vault_kms_keyring_name     = var.vault_kms_keyring_name
      vault_kms_keyring_location = var.vault_kms_keyring_location
    }
  )

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.vault_instance.email
    scopes = ["cloud-platform"]
  }
}
