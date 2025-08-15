/*
resource "google_cloudfunctions2_function" "pubsub_fn" {
  name     = "pubsub-python313-fn"
  location = var.region

  build_config {
    runtime     = "python313"
    entry_point = "trigger_retraining" # from main.py

    source {
      storage_source {
        bucket = google_storage_bucket.kubeflow-testing.name
        object = google_storage_bucket_object.function_source_archive.name
      }
    }
  }

  service_config {
    available_memory   = "256M"
    max_instance_count = 2
    timeout_seconds    = 60
  }

  event_trigger {
    trigger_region = var.bucket_location
    event_type     = "google.cloud.pubsub.topic.v1.messagePublished"
    pubsub_topic   = "projects/${var.project_id}/topics/${google_pubsub_topic.model_monitoring.name}"
    retry_policy   = "RETRY_POLICY_RETRY"
  }
}
*/