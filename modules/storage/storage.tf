resource "google_storage_bucket" "tf-bucket" {
  name               = "tf-bucket-817906"
  location           = "US"
  force_destroy      = true
  uniform_bucket_level_access = true
}
