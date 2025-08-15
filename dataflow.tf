/*
resource "google_dataflow_job" "batch_job" {
  name       = "germananalysis"
  template_gcs_path    = "gs://demo_bucket_kfl/Template/germananalysis_batch"
  temp_gcs_location    = "gs://demo_bucket_kfl/Temp"
  region               = "asia-south1"
  on_delete            = "cancel"  # optional: cancel job if resource is destroyed
  max_workers          = 2         # optional

  parameters = {
    input = "gs://demo_bucket_kfl/german_data.csv"
  }

  lifecycle {
    ignore_changes = all
  }
}
*/
/*
resource "null_resource" "run_batch_pipeline" {
  provisioner "local-exec" {
    command = <<EOT
      python3 batch-pipeline.py \
        --runner DataFlowRunner \
        --project solar-dialect-264808 \
        --temp_location gs://demo_bucket_kfl/Temp \
        --staging_location gs://demo_bucket_kfl/Stage \
        --input gs://demo_bucket_kfl/german_data.csv \
        --region asia-south2 \
        --job_name germananalysis
    EOT
  }
}
*/
/*
resource "google_dataflow_job" "streaming_job" {
  name              = "ml-stream-analysis"
  template_gcs_path = "gs://demo_bucket_kfl/Template/germananalysis_streaming"
  temp_gcs_location = "gs://demo_bucket_kfl/Temp"
  region            = var.region
  on_delete         = "cancel"
  max_workers       = 1
  enable_streaming_engine = true

  parameters = {
    input_subscription = "projects/${var.project_id}/subscriptions/${google_pubsub_subscription.streaming_data_subscription.name}"
    input_topic        = "projects/${var.project_id}/topics/${google_pubsub_topic.streaming_data.name}"
    bucket_name        = "demo_bucket_kfl"
  }

}
*/