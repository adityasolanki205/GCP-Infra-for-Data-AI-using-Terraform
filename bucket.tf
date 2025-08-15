/*
resource "google_storage_bucket" "kubeflow-testing" {
  name     = var.bucket_name
  location = var.bucket_location
  storage_class = "STANDARD"

  uniform_bucket_level_access = true
  force_destroy = true

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

resource "google_storage_bucket_object" "subfolder_template" {
  name   = "Template/"  
  bucket = google_storage_bucket.kubeflow-testing.name
  source = '/home/aditya_solanki205/GCP-Infra-for-Data-AI-using-Terraform/Template/*'
  content = "template" 
}

resource "google_storage_bucket_object" "subfolder_pipeline_root" {
  name   = "pipeline_root_demo/"  
  bucket = google_storage_bucket.kubeflow-testing.name
  content = "pipeline_root_demo" 
}

resource "google_storage_bucket_object" "function_source_archive" {
      name   = "function.zip"
      bucket = google_storage_bucket.kubeflow-testing.name
      source = "/home/aditya_solanki205/GCP-Infra-for-Data-AI-using-Terraform/function.zip" # Path to your local zip file
    }
*/