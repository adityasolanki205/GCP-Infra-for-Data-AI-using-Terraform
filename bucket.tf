#resource "google_storage_bucket" "kubeflow-testing" {
#  name     = var.bucket_name
#  location = var.bucket_location
#  storage_class = "STANDARD"

#  uniform_bucket_level_access = true

#  versioning {
#    enabled = false
#  }

#  lifecycle_rule {
#    action {
#      type = "Delete"
#   }
#    condition {
#      age = 30
#    }
#  }

#  labels = {
#    environment = "dev"
#    purpose     = "bucket-testing"
#  }
#}
