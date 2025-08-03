# Create a Pub/Sub topic
resource "google_pubsub_topic" "streaming_data" {
  name = "german_credit_data"
}

# Create a pull subscription to the topic
resource "google_pubsub_subscription" "streaming_data_subscription" {
  name  = "german_credit_data-sub"
  topic = google_pubsub_topic.streaming_data.id

  ack_deadline_seconds = 60  # how long subscriber has to ack
}

# Create a Pub/Sub topic
resource "google_pubsub_topic" "model_monitoring" {
  name = "Model_Monitoring"
}

# Create a pull subscription to the topic
resource "google_pubsub_subscription" "model_monitoring_subscription" {
  name  = "Model_Monitoring-sub"
  topic = google_pubsub_topic.model_monitoring.id

  ack_deadline_seconds = 60  # how long subscriber has to ack
}
