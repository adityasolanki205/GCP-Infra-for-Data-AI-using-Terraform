/*
resource "google_artifact_registry_repository" "demo_mode_repo" {
  location      = "asia-south1"                     # Replace with your preferred region
  repository_id = "kubeflow-pipelines"               # The name of your repo
  description   = "Docker container repository for model"
  format        = "DOCKER"                          # Could be: DOCKER, MAVEN, NPM, PYTHON, APT, etc.
  cleanup_policies {
        id = "delete-old-artifacts"
        action = "DELETE"
        condition {
          older_than = "30d" # Deletes artifacts older than 30 days
        }
  }
  labels = {
    environment = "dev"
    managed_by  = "terraform"
  }
}
*/