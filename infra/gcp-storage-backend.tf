resource "google_storage_bucket" "vault_storage_backend" {
  # suffix by project ID, as GCS names are globally unique 
  name     = "${var.vault_gcs_bucket_name}-${var.gcp_project_id}"
  location = var.vault_gcs_location != "" ? upper(var.vault_gcs_location) : upper(split("-", var.gcp_zone)[0])

  # error on attempt to delete
  # if you are unsure what deletion of this bucket means, changing it is NOT RECOMMENDED
  force_destroy = false

  uniform_bucket_level_access = true
}

resource "google_storage_bucket_iam_binding" "vault_storage_backend" {
  bucket = google_storage_bucket.vault_storage_backend.name
  role   = "roles/storage.admin"
  members = [
    "serviceAccount:${google_service_account.vault_instance.email}",
  ]
}
