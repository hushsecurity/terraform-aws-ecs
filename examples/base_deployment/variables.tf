variable "aws_region" {
  description = "AWS region for ECS deployment"
  type        = string
  default     = "eu-west-1"
}

variable "cluster_name" {
  description = "Name of the ECS cluster to deploy into"
  type        = string
}

variable "service_name" {
  description = "Name of the ECS service"
  type        = string
  default     = "hush-sensor-daemon"
}

# ==== Sensor Image Configuration ====
variable "sensor_image_repo" {
  description = "Repository name for the main sensor image"
  type        = string
  default     = "sensor"
}

variable "sensor_vector_image_repo" {
  description = "Repository name for the vector sidecar"
  type        = string
  default     = "sensor-vector"
}

variable "image_tag" {
  description = "Tag to use for both images"
  type        = string
  default     = "v0"
}

# ==== Deployment Identity ====
variable "deployment_token" {
  description = "Base64-encoded token to be passed directly to the container"
  type        = string
  sensitive   = true
}

variable "deployment_password" {
  description = "Deployment password used for EVENT_REPORTING_TOKEN"
  type        = string
  sensitive   = true
  default     = null
}

variable "deployment_password_arn" {
  description = "Pre-existing ARN for EVENT_REPORTING_TOKEN (optional)"
  type        = string
  default     = null
}

# ==== ACR Credentials ====
variable "acr_registry" {
  description = "ACR registry hostname (e.g. hushdev.azurecr.io)"
  type        = string
  default     = null
}

variable "acr_username" {
  description = "Username for ACR image pull"
  type        = string
  default     = null
}

variable "acr_password" {
  description = "Password for ACR image pull"
  type        = string
  sensitive   = true
  default     = null
}

variable "acr_credentials_secret_arn" {
  description = "Pre-existing secret ARN for ACR pull credentials (optional)"
  type        = string
  default     = null
}

# ==== Runtime Configuration ====
variable "event_reporting_uri" {
  description = "Endpoint for event reporting"
  type        = string
  default     = "https://events.us.hush-security.com/v1/runtime-events"
}

variable "log_reporting_uri" {
  description = "Endpoint for log reporting"
  type        = string
  default     = "https://events.us.hush-security.com/v1/runtime-logs"
}

variable "event_reporting_console" {
  description = "Optional reporting console"
  type        = string
  default     = "n"
}

variable "event_reporting_console_pretty" {
  description = "Optional pretty reporting console"
  type        = string
  default     = "n"
}

# ==== ECS Resource Sizing ====
variable "task_cpu" {
  description = "CPU units for ECS task"
  type        = string
  default     = "256"
}

variable "task_memory" {
  description = "Memory (in MiB) for ECS task"
  type        = string
  default     = "1024"
}

# ==== Sensor Runtime Flags ====
variable "trace_host" {
  description = "Enable tracing of the host system"
  type        = string
  default     = "false"
}

variable "trace_pods_default" {
  description = "Enable pod tracing by default"
  type        = string
  default     = "false"
}

variable "report_tls" {
  description = "Enable reporting of TLS metadata"
  type        = string
  default     = "false"
}

variable "cri_socket_path" {
  description = "Path to the CRI socket used by the sensor"
  type        = string
  default     = "/var/run/containerd/containerd.sock"
}

variable "akeyless_gateway_domain" {
  description = "Optional domain override for the Akeyless gateway"
  type        = string
  default     = ""
}
