variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "Default region for GCP resources"
  type        = string
  default     = "asia-south1"
}

variable "bucket_name" {
  description = "Globally unique name for the GCS bucket"
  type        = string
}

variable "bucket_location" {
  description = "Bucket location"
  type        = string
}

variable "project_number" {
  description = "project number"
  type = string
  default = "827249641444"
}
