resource "google_storage_bucket" "bucket" {
  name     = var.bucket_name
  location = var.location
  public_access_prevention = "inherited"
  uniform_bucket_level_access = true
  website {
    main_page_suffix = "index.html"
  }
}

# Make bucket public
resource "google_storage_bucket_iam_member" "member" {
  provider = google
  bucket   = google_storage_bucket.bucket.name
  role     = "roles/storage.objectViewer"
  member   = "allUsers"
}

output "bucket_name" {
  value = google_storage_bucket.bucket.name
}
