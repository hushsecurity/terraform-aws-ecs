provider "aws" {
  region = var.aws_region
}

module "sensor_daemon" {
  source = "../../modules/sensor_daemon"

  # Core
  aws_region   = var.aws_region
  cluster_name = var.cluster_name
  service_name = var.service_name

  # Sensor image configuration
  sensor_image_repo        = var.sensor_image_repo
  sensor_vector_image_repo = var.sensor_vector_image_repo
  image_tag                = var.image_tag

  # Runtime config
  event_reporting_uri            = var.event_reporting_uri
  log_reporting_uri              = var.log_reporting_uri
  event_reporting_console        = var.event_reporting_console
  event_reporting_console_pretty = var.event_reporting_console_pretty
  task_cpu                       = var.task_cpu
  task_memory                    = var.task_memory

  # ==== Deployment Identity ====
  deployment_token = var.deployment_token
  acr_registry     = var.acr_registry

  # Option 1: Provide secrets (will be uploaded)
  # deployment_password = var.deployment_password

  # Option 2: Use existing secrets (uncomment below and remove option 1)
  deployment_password_arn = var.deployment_password_arn

  # ==== Image Pull ====
  # Option 1: Provide ACR credentials (will be uploaded)
  # acr_username = var.acr_username
  # acr_password = var.acr_password

  # Option 2: Use existing secret ARN (uncomment below and remove option 1)
  acr_credentials_secret_arn = var.acr_credentials_secret_arn
}
