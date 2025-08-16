# GCP Infra for Data & AI using Terraform
This repository is part of an **Terraform code**, showcasing a Infrastructure codes to create pipelines that integrates **data engineering** and **machine learning** for real-time **credit risk prediction** 

You'll learn key concepts like **data ingestion**, **ETL (Extract, Transform, Load)**, **data warehousing**, **ML model deployment**, and **online prediction** using **Kubeflow** , **Terraform** and various **GCP services**.

We use the [German Credit Risk dataset](https://www.kaggle.com/uciml/german-credit) and simulate a **streaming data source** that emits customer details in real time. The pipeline is designed to predict customer credit risk, covering the full lifecycle — from batch ingestion and processing, to model training, deployment, online inference using Terraform — detailed in the architecture diagram below

![ML Ops Architecture Updated](https://github.com/user-attachments/assets/d6b79fb6-f4e0-4ef2-8025-b416da27da17)

## Infrastructure Components

1. **Create GCS Buckets**  
   - Storage for raw data, processed datasets, model artifacts, and logs.  
   - Configurable bucket names, locations, and lifecycle rules.  

2. **Create Pub/Sub Topics & Subscriptions**  
   - Topics for streaming ingestion of real-time data.  
   - Subscriptions for downstream processing in Dataflow or Cloud Functions.

3. **Create BigQuery Datasets & Tables**  
   - Datasets for storing cleaned/transformed data and prediction results.  
   - Optimized schemas for analytics and machine learning use cases. 

4. **Create Artifact Registry**  
   - Stores container images, model packages, and pipeline artifacts.  
   - Supports Docker and language-specific repositories.  

5. **Create Dataflow Jobs**  
   - Batch and streaming jobs for ETL pipelines using Apache Beam.  
   - Automatically triggered for historical and real-time data processing.   

6. **Provision Vertex AI Workbench**  
   - Instances for data exploration, feature engineering, and model development.

7. **Run pipeline from Workbench (Without terraform)**
   - Run the pipeline to from workbench. Currently there is no terraform code available. 

9. **Create Model Monitoring and cloud alerting (Without terraform)**
   - Similar to Vertex AI pipeline, there is not terraform code avaialble for model_monitoring and cloud alerting policy

11. **Deploy Cloud Functions**  
   - Event-driven functions for pipeline orchestration, model retraining, and alerts handling.  


## Motivation
For the last few years, I have been part of a great learning curve wherein I have upskilled myself to move into a Machine Learning and Cloud Computing. This project was practice project for all the learnings I have had. This is first of the many more to come. 
 

## Libraries/frameworks used

<b>Built with</b>
- [Anaconda](https://www.anaconda.com/)
- [Python](https://www.python.org/)
- [Vertex AI](https://cloud.google.com/vertex-ai?hl=en)
- [Google Cloud Storage](https://cloud.google.com/storage)
- [Artifact Registry](https://cloud.google.com/artifact-registry/docs)
- [Cloud Build](https://cloud.google.com/build/docs)
- [Vertex AI Workbench](https://cloud.google.com/vertex-ai-notebooks?hl=en)
- [Vertex AI Model Registry](https://cloud.google.com/vertex-ai/docs/model-registry/introduction)
- [Vertex AI Online Prediction](https://cloud.google.com/vertex-ai/docs/predictions/get-predictions)
- [Vertex AI Metadata](https://cloud.google.com/vertex-ai/docs/ml-metadata/introduction)
- [Pub Sub](https://cloud.google.com/pubsub/docs)
- [Cloud Alerting](https://cloud.google.com/monitoring/alerts)
- [Cloud Run Functions](https://cloud.google.com/functions/docs)
- [Apache Beam](https://beam.apache.org/documentation/programming-guide/)
- [Google DataFlow](https://cloud.google.com/dataflow)
- [Terraform](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
- 
## Cloning Repository

```bash
    # clone this repo:
    git clone https://github.com/adityasolanki205/GCP-Infra-for-Data-AI-using-Terraform.git
```

## Initial Setup

1. **Setup**: First we will have to setup free google cloud account which can be done [here](https://cloud.google.com/free). Then we need to Download the data from [German Credit Risk](https://www.kaggle.com/uciml/german-credit). Also present in the repository [here](https://github.com/adityasolanki205/Unified-ETL-DWH-MLOps-Pipeline/blob/main/german_data.csv)
   
2. **Cloning the Repository in Cloud SDK**: We will be cloning the repository in cloud SDK and will be runnning our terraform from there. Terraform is preinstalled in cloud SDK.

3. Simple Steps to run the terraform code:

    a. terraform init
    b. terraform plan
    c. terraform apply

## Pipeline construction using Terraform components

### 1. **Create GCS Buckets**

Now we will go step by step to create Storage bucket to be used for raw data, processed datasets, model artifacts, and logs.

```hcl
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
      source = "/home/<GCP User ID>/GCP-Infra-for-Data-AI-using-Terraform/function.zip" # Path to your local zip file
    }
```
After this there a few files to be copied to GCS bucket. So run the commands on SDK as mentioned below:

```cmd
gsutil cp ./Template/* gs://demo_bucket_kfl/Template/*
gsutil cp german_data.csv gs://demo_bucket_kfl/
```

### 2. **Create Pub/Sub Topics & Subscriptions**

Pub/Sub acts as the **messaging backbone** for streaming data ingestion.  
We will create a **topic** for publishing events and a **subscription** for downstream consumers such as **Dataflow jobs**.

```hcl
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
```

### 3. **Create BigQuery Datasets & Tables**

BigQuery serves as the **data warehouse** where cleaned, transformed, and prediction data is stored.  
We will create a dataset and define tables optimized for **analytics** and **machine learning** use cases.

```hcl
resource "google_bigquery_dataset" "ml_dataset" {
    dataset_id                  = "GermanCredit" # Replace with your desired dataset ID
    friendly_name               = "GermanCredit dataset"
    description                 = "GermanCredit dataset created from terraform"
    location                    = "asia-south1" # Replace with your desired location (e.g., "US", "EU")
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
      "type": "string",
      "mode": "NULLABLE"
    },
	{
      "name": "Foreign_worker",
      "type": "string",
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
      "type": "string",
      "mode": "NULLABLE"
    },
	{
      "name": "Foreign_worker",
      "type": "string",
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
```

##### Related code
1. [batch-pipeline.py](https://github.com/adityasolanki205/Unified-ETL-DWH-MLOps-Pipeline/blob/main/batch-pipeline.py)

#### 🎥 ***Demo Video***
https://github.com/user-attachments/assets/fadb5172-8c24-40f9-aee0-190a2562d170


### 4. **Create Artifact Registry**

Artifact Registry is used to securely store and manage **container images**, **pipeline artifacts**, and **ML models**.  
By using Artifact Registry, we ensure **version control, reproducibility, and centralized management** of all components required for the MLOps pipeline.

The following Terraform code creates a Docker repository inside Artifact Registry:

```hcl
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
```
##### Related Code
1. [training_pipeline.py](https://github.com/adityasolanki205/Unified-ETL-DWH-MLOps-Pipeline/blob/main/training_pipeline.py)

    
### 5. **Create Dataflow Jobs**

Dataflow is a **serverless processing service** for running both **batch** and **streaming ETL pipelines**.  
In this pipeline, Dataflow jobs are responsible for **reading data from Pub/Sub (streaming)** or **GCS (batch)**, cleaning, transforming, and then loading the results into **BigQuery**.  

We use Terraform to define and deploy Dataflow Flex Templates, which make it easy to run standardized jobs without manual setup.

```hcl
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
```
##### Related code
1. [batch-pipeline.py](https://github.com/adityasolanki205/Unified-ETL-DWH-MLOps-Pipeline/blob/main/batch-pipeline.py)
   
### 6. **Provision Vertex AI Workbench**

Vertex AI Workbench provides **managed JupyterLab environments** for data scientists and ML engineers.  
It allows you to perform **data exploration**, **feature engineering**, **experimentation**, and **pipeline development** in a scalable and secure environment.  

Using Terraform, we can provision a Vertex AI Workbench instance with the required configurations such as machine type, disk size, and network settings.

```hcl
resource "google_workbench_instance" "default" {
  name     = "workbench-instance"
  location = "asia-south1-a"

  gce_setup {
    machine_type = "e2-standard-4"
    vm_image {
      project = "cloud-notebooks-managed"
      family  = "workbench-instances"
    }
  }
}
```
##### Related code
1. [batch-pipeline.py](https://github.com/adityasolanki205/Unified-ETL-DWH-MLOps-Pipeline/blob/main/batch-pipeline.py)


### 7. **Run pipeline from Workbench**

So currently terraform cannot create Vertex AI pipelines. So please follow the video to create the pipeline. 


### 8. **Create Model Monitoring and cloud alerting**

Also  terraform cannot create Vertex AI model monitoring. So please follow the video to create the model monitoring and cloud alerting policy. 


### 9. **Deploy Cloud Functions**

Cloud Functions provide a **serverless execution environment** for running lightweight, event-driven code.  
In this pipeline, they are used for **orchestration**, **alert handling**, and **automated retraining triggers**.  

Using Terraform, we can deploy a Cloud Function that responds to **Pub/Sub messages** or **log-based alerts** and triggers downstream actions (e.g., restarting a pipeline, invoking retraining, or writing logs).

```hcl
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
```
##### Related code
1. [batch-pipeline.py](https://github.com/adityasolanki205/Unified-ETL-DWH-MLOps-Pipeline/blob/main/batch-pipeline.py)

### 10. **Delete Infrastructure (Optional)**

Comment all the codes and it will delete all the infrastructure.

## Implementation
To test the code we need to do the following:

    1. Copy the repository in Cloud SDK using below command:
    git clone https://github.com/adityasolanki205/Unified-ETL-DWH-MLOps-Pipeline.git
    
    2. Create a Storage Bucket by the name 'demo_bucket_kfl' in asia-south1 and two sub folders Temp and Stage.
    
    3. Copy the data file in the cloud Bucket using the below command
    cd ML_Pipeline_using_Kubeflow
    gsutil cp german_data.csv gs://demo_bucket_kfl/
    
    4. Create a Dataset in asia-east1 by the name GermanCredit
    
    5. Create a table in GermanCredit dataset by the name GermanCreditTable. 
        Schema is present at the starting of batch-pipeline.py

    6. Create a table in GermanCredit dataset by the name GermanCreditTable-streaming. 
        Schema is present at the starting of ml-streaming-pipeline-endpoint.py

    7. Create Pub Sub Topic by the name german_credit_data and Model_Monitoring
    
    8. Install Apache Beam on the SDK using below command
    pip3 install apache_beam[gcp]
    
    9. Command to run Batch job:
     python3 batch-pipeline.py \
     --runner DataFlowRunner \
     --project solar-dialect-264808 \
     --temp_location gs://demo_bucket_kfl/Temp \
     --staging_location gs://demo_bucket_kfl/Stage \
     --input gs://demo_bucket_kfl/german_data.csv \
     --region asia-south1 \
     --job_name germananalysis

    10. Run the file training_pipeline.ipynb/training_pipeline.py in workbench. This will create a json file.
    
    11. Run the run_pipeline.ipynb file
     
    12. Verify of all the artifacts are created.
    
    13. The Streaming pipeline will run with below configuration only. To configure environment run commands present in update_python.ipynb
        Python 3.11, apache-beam[gcp]==2.64.0

    14. Run the pipeline using:
    python3 ml-streaming-pipeline-endpoint.py \
      --runner DataFlowRunner \
      --project solar-dialect-264808 \
      --bucket_name demo_bucket_kfl \
      --temp_location gs://demo_bucket_kfl/Temp \
      --staging_location gs://demo_bucket_kfl/Stage \
      --region asia-south1 \
      --job_name ml-stream-analysis \
      --input_subscription projects/solar-dialect-264808/subscriptions/german_credit_data-sub \
      --input_topic projects/solar-dialect-264808/topics/german_credit_data \
      --save_main_session \
      --setup_file ./setup.py \
      --max_num_workers 1 \
      --streaming
      
    15. Open one more tab in cloud SDK and run below command 
    cd ML-Streaming-pipeline-using-Dataflow
    python3 publish_to_pubsub.py

    16. Goto Model Monitoring and setup model monitoring for output drift detection

    17. Create a Alerting policy for Model output drift deviation with threshold as 0.3 and select notification 
    channel as model_monitoring topic in pub sub. 

    18. Create a Cloud Run functions that listens for Pub Sub and triggers retraining pipeline. So when cloud alerting
    triggers a message to Pub sub, Cloud Run Functions gets invoked and starts retraining.

## Credits
1. Akash Nimare's [README.md](https://gist.github.com/akashnimare/7b065c12d9750578de8e705fb4771d2f#file-readme-md)
2. [Building a Kubeflow Training Pipeline on Google Cloud: A Step-by-Step Guide](https://medium.com/@rajmudigonda893/building-a-kubeflow-training-pipeline-on-google-cloud-a-step-by-step-guide-761a6b0eb197)
3. [Deploy ML Training Pipeline Using Kubeflow](https://medium.com/@kavinduhapuarachchi/deploy-ml-training-pipeline-using-kubeflow-19d52d22f44f)
4. [A Beginner’s Guide to Kubeflow on Google Cloud Platform](https://medium.com/@vishwanath.prudhivi/a-beginners-guide-to-kubeflow-on-google-cloud-platform-5d02dbd2ec5e)
5. [MLOps 101 with Kubeflow and Vertex AI](https://medium.com/google-cloud/mlops-101-with-kubeflow-and-vertex-ai-61f6f5489fa8)
