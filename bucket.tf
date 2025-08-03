resource "google_storage_bucket" "kubeflow-testing" {
  name     = var.bucket_name
  location = var.bucket_location
  storage_class = "STANDARD"

  uniform_bucket_level_access = true

  versioning {
    enabled = false
  }

  lifecycle_rule {
    action {
      type = "Delete"
   }
    condition {
      age = 30
    }
  }

  labels = {
    environment = "dev"
    purpose     = "bucket-testing"
  }
}

resource "google_storage_bucket_object" "subfolder_temp" {
  name   = "Temp/"   
  bucket = google_storage_bucket.kubeflow-testing.name
  content = "temp" 
}

resource "google_storage_bucket_object" "subfolder_stage" {
  name   = "Stage/"  
  bucket = google_storage_bucket.kubeflow-testing.name
  content = "stage" 
}
