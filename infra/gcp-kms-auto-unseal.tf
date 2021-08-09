# Create a KMS key ring
resource "google_kms_key_ring" "vault_auto_unseal" {
  count = var.vault_kms_auto_unseal ? 1 : 0

  project  = var.gcp_project_id
  name     = var.vault_kms_keyring_name
  location = var.vault_kms_keyring_location
}

# Create a crypto key for the key ring
resource "google_kms_crypto_key" "vault_auto_unseal" {
  count = var.vault_kms_auto_unseal ? 1 : 0

  name            = google_kms_key_ring.vault_auto_unseal[0].name
  key_ring        = google_kms_key_ring.vault_auto_unseal[0].self_link
  rotation_period = "100000s"
}

# Add the vault instance service account as the owener of keyring
resource "google_kms_key_ring_iam_binding" "vault_iam_kms_binding" {
  count = var.vault_kms_auto_unseal ? 1 : 0

  key_ring_id = google_kms_key_ring.vault_auto_unseal[0].id
  role        = "roles/owner"

  members = [
    "serviceAccount:${google_service_account.vault_instance.email}",
  ]
}
