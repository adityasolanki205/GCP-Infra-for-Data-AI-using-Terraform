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
resource "null_resource" "run_streaming_pipeline" {
  provisioner "local-exec" {
    command = <<EOT
      python3 ml-streaming-pipeline-endpoint.py \
        --runner DataFlowRunner \
        --project solar-dialect-264808 \
        --bucket_name demo_bucket_kfl \
        --temp_location gs://demo_bucket_kfl/Temp \
        --staging_location gs://demo_bucket_kfl/Stage \
        --region asia-south2 \
        --job_name ml-stream-analysis \
        --input_subscription projects/solar-dialect-264808/subscriptions/german_credit_data-sub \
        --input_topic projects/solar-dialect-264808/topics/german_credit_data \
        --save_main_session \
        --setup_file ./setup.py \
        --max_num_workers 1 \
        --streaming
    EOT
  }
}
*/