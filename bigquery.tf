/*
resource "google_bigquery_dataset" "ml_dataset" {
    dataset_id                  = "GermanCredit" # Replace with your desired dataset ID
    friendly_name               = "GermanCredit dataset"
    description                 = "GermanCredit dataset created from terraform"
    location                    = "asia-south2" # Replace with your desired location (e.g., "US", "EU")
    default_table_expiration_ms = 3600000 # Optional: default table expiration in milliseconds (e.g., 1 hour)
    labels = {
    environment = "development"
    managed_by  = "terraform"
    }
}
resource "google_bigquery_table" "batch-table" {
  dataset_id = google_bigquery_dataset.ml_dataset.dataset_id
  table_id   = "GermanCreditTable"
  deletion_protection = false
  schema = jsonencode([
    {
      "name": "Existing_account",
      "type": "string",
      "mode": "NULLABLE"
    },
    {
      "name": "Duration_month",
      "type": "integer",
      "mode": "NULLABLE"
    },
	{
      "name": "Credit_history",
      "type": "string",
      "mode": "NULLABLE"
    },
	{
      "name": "Purpose",
      "type": "string",
      "mode": "NULLABLE"
    },
	{
      "name": "Credit_amount",
      "type": "float",
      "mode": "NULLABLE"
    },
	{
      "name": "Saving",
      "type": "string",
      "mode": "NULLABLE"
    },
	{
      "name": "Employment_duration",
      "type": "string",
      "mode": "NULLABLE"
    },
	{
      "name": "Installment_rate",
      "type": "integer",
      "mode": "NULLABLE"
    },
	{
      "name": "Personal_status",
      "type": "string",
      "mode": "NULLABLE"
    },
	{
      "name": "Debtors",
      "type": "string",
      "mode": "NULLABLE"
    },
	{
      "name": "Residential_Duration",
      "type": "integer",
      "mode": "NULLABLE"
    },
	{
      "name": "Property",
      "type": "string",
      "mode": "NULLABLE"
    },
	{
      "name": "Age",
      "type": "integer",
      "mode": "NULLABLE"
    },
	{
      "name": "Installment_plans",
      "type": "string",
      "mode": "NULLABLE"
    },
	{
      "name": "Housing",
      "type": "string",
      "mode": "NULLABLE"
    },
	{
      "name": "Number_of_credits",
      "type": "integer",
      "mode": "NULLABLE"
    },
	{
      "name": "Job",
      "type": "string",
      "mode": "NULLABLE"
    },
	{
      "name": "Liable_People",
      "type": "integer",
      "mode": "NULLABLE"
    },
	{
      "name": "Telephone",
      "type": "integer",
      "mode": "NULLABLE"
    },
	{
      "name": "Foreign_worker",
      "type": "integer",
      "mode": "NULLABLE"
    },
    {
	  "name": "Classification",
	  "type": "integer",
	  "mode": "NULLABLE"
	}
  ])
}

resource "google_bigquery_table" "streaming-table" {
  dataset_id = google_bigquery_dataset.ml_dataset.dataset_id
  table_id   = "GermanCreditTable-streaming"
  deletion_protection = false
  schema = jsonencode([
    {
      "name": "Existing_account",
      "type": "string",
      "mode": "NULLABLE"
    },
    {
      "name": "Duration_month",
      "type": "integer",
      "mode": "NULLABLE"
    },
	{
      "name": "Credit_history",
      "type": "string",
      "mode": "NULLABLE"
    },
	{
      "name": "Purpose",
      "type": "string",
      "mode": "NULLABLE"
    },
	{
      "name": "Credit_amount",
      "type": "float",
      "mode": "NULLABLE"
    },
	{
      "name": "Saving",
      "type": "string",
      "mode": "NULLABLE"
    },
	{
      "name": "Employment_duration",
      "type": "string",
      "mode": "NULLABLE"
    },
	{
      "name": "Installment_rate",
      "type": "integer",
      "mode": "NULLABLE"
    },
	{
      "name": "Personal_status",
      "type": "string",
      "mode": "NULLABLE"
    },
	{
      "name": "Debtors",
      "type": "string",
      "mode": "NULLABLE"
    },
	{
      "name": "Residential_Duration",
      "type": "integer",
      "mode": "NULLABLE"
    },
	{
      "name": "Property",
      "type": "string",
      "mode": "NULLABLE"
    },
	{
      "name": "Age",
      "type": "integer",
      "mode": "NULLABLE"
    },
	{
      "name": "Installment_plans",
      "type": "string",
      "mode": "NULLABLE"
    },
	{
      "name": "Housing",
      "type": "string",
      "mode": "NULLABLE"
    },
	{
      "name": "Number_of_credits",
      "type": "integer",
      "mode": "NULLABLE"
    },
	{
      "name": "Job",
      "type": "string",
      "mode": "NULLABLE"
    },
	{
      "name": "Liable_People",
      "type": "integer",
      "mode": "NULLABLE"
    },
	{
      "name": "Telephone",
      "type": "integer",
      "mode": "NULLABLE"
    },
	{
      "name": "Foreign_worker",
      "type": "integer",
      "mode": "NULLABLE"
    },
    {
	  "name": "Classification",
	  "type": "integer",
	  "mode": "NULLABLE"
	},
    {
	  "name": "datetime",
	  "type": "TIMESTAMP",
	  "mode": "NULLABLE"
	}
  ])
}
*/