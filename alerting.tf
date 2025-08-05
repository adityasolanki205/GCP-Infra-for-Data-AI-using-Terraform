/*
resource "google_monitoring_notification_channel" "email" {
  display_name = "Drift Email Alerts"
  type         = "email"

  labels = {
    email_address = "aditya.solanki205@gmail.com"
  }
}
resource "google_monitoring_notification_channel" "pubsub" {
  display_name = "Drift PubSub Alerts"
  type         = "pubsub"

  labels = {
    topic = google_pubsub_topic.model_monitoring.id
  }
}
resource "google_pubsub_topic_iam_member" "monitoring_publisher" {
  topic = google_pubsub_topic.model_monitoring.name
  role  = "roles/pubsub.publisher"
  member = "serviceAccount:service-${var.project_number}@gcp-sa-monitoring-notification.iam.gserviceaccount.com"
}


resource "google_monitoring_alert_policy" "output_drift_alert" {
  display_name = "Vertex AI Output Drift Deviation Alert"
  combiner     = "OR"

  conditions {
    display_name = "Output Drift > 0.30"

    condition_threshold {
      filter = <<EOT
            metric.type="aiplatform.googleapis.com/endpoint/prediction_output_drift"
            AND resource.type="vertex_ai_endpoint"
            EOT

      duration         = "60s"
      comparison       = "COMPARISON_GT"
      threshold_value  = 0.30

      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_MAX"
      }
    }
  }

  notification_channels = [
    google_monitoring_notification_channel.email.name,
    google_monitoring_notification_channel.pubsub.name
  ]

  alert_strategy {
    auto_close = "3600s"
  }

  user_labels = {
    environment = "prod"
  }
}

*/