# ─────────────────────────────────────────────
# Required core deployment configuration
# ─────────────────────────────────────────────
variable "cluster_name" {
  description = "Name of the ECS cluster to deploy into"
  type        = string

  validation {
    condition     = length(trim(var.cluster_name, " ")) > 0
    error_message = "The 'cluster_name' value is required and cannot be empty"
  }
}

variable "enable_sensor" {
  description = "Whether to deploy the Hush sensor"
  type        = bool
  default     = true
}

variable "enable_vermon" {
  description = "Whether to deploy the Vermon auto-upgrade component"
  type        = bool
  default     = true
}

# ─────────────────────────────────────────────
# Service naming configuration
# ─────────────────────────────────────────────
variable "sensor_service_name" {
  description = "Name of the ECS service for the sensor"
  type        = string
  default     = "hush-sensor-daemon"
}

variable "vermon_service_name" {
  description = "Name of the ECS service for vermon"
  type        = string
  default     = "hush-vermon"
}

variable "sensor_task_definition_family" {
  description = "Name of the ECS task definition family for the sensor"
  type        = string
  default     = "hush-sensor-service"
}

variable "vermon_task_definition_family" {
  description = "Name of the ECS task definition family for vermon"
  type        = string
  default     = "hush-vermon-service"
}

# ─────────────────────────────────────────────
# Runtime configuration and behavior toggles
# ─────────────────────────────────────────────
variable "event_reporting_console" {
  description = "Enable console event reporting"
  type        = string
  default     = "heartbeat"
}

variable "trace_host" {
  description = "Enable host tracing"
  type        = bool
  default     = false
}

variable "trace_pods_default" {
  description = "Enable pod tracing by default"
  type        = bool
  default     = true
}

variable "report_tls" {
  description = "Enable TLS metadata reporting"
  type        = bool
  default     = false
}

variable "cri_socket_path" {
  description = "Absolute path to the CRI socket used by the sensor (e.g., /var/run/containerd/containerd.sock)"
  type        = string
  default     = ""
}

variable "docker_socket_path" {
  description = "Absolute path to the Docker socket used by the sensor"
  type        = string
  default     = "/var/run/docker.sock"
}

variable "akeyless_gateway_domain" {
  description = "Custom Akeyless gateway domain (optional)"
  type        = string
  default     = ""
}

# ─────────────────────────────────────────────
# Container image configuration
# ─────────────────────────────────────────────
variable "sensor_tag" {
  description = "Tag to use for sensor container images"
  type        = string
  default     = "v0"
}

variable "sensor_image_repo" {
  description = "Repository name for the sensor container"
  type        = string
  default     = "sensor"
}

variable "sensor_vector_image_repo" {
  description = "Repository name for the vector sidecar container"
  type        = string
  default     = "sensor-vector"
}

variable "vermon_image_repo" {
  description = "Repository name for the vermon container"
  type        = string
  default     = "vermon"
}

# ─────────────────────────────────────────────
# Vermon auto-upgrade configuration
# ─────────────────────────────────────────────
variable "vermon_update_frequency" {
  description = "How often Vermon checks for updates (e.g., '8h', '5m')"
  type        = string
  default     = "8h"
}

# ─────────────────────────────────────────────
# Registry credentials
# ─────────────────────────────────────────────
variable "container_registry" {
  description = "Container registry hostname"
  type        = string
  default     = "hushsecurity.azurecr.io"
}

variable "container_registry_username" {
  description = "Username for container registry pull access"
  type        = string
  default     = null
}

variable "container_registry_password" {
  description = "Password for container registry pull access"
  type        = string
  sensitive   = true
  default     = null
}

variable "container_registry_credentials_secret_arn" {
  description = "If a secret is provided, the 'container_registry_username' and 'container_registry_password' variables will be ignored. The secret must be a JSON object with the fields \"username\", and \"password\""
  type        = string
  default     = null
}

# ─────────────────────────────────────────────
# Deployment credentials
# ─────────────────────────────────────────────
variable "deployment_token" {
  description = "Deployment token"
  type        = string
  sensitive   = true
  default     = null
}

variable "deployment_password" {
  description = "Deployment password"
  type        = string
  sensitive   = true
  default     = null
}

variable "deployment_credentials_secret_arn" {
  description = "If a secret is provided, the 'deployment_token' and 'deployment_password' variables will be ignored. The secret must be a JSON object containing both the 'deployment_token' and 'deployment_password' fields."
  type        = string
  default     = null
}

# ─────────────────────────────────────────────
# Network configuration for awsvpc mode (sensor only)
# ─────────────────────────────────────────────
variable "vpc_private_subnets" {
  description = "List of VPC private subnet IDs for ECS task placement in awsvpc network mode. Must be private subnets with NAT Gateway for internet access."
  type        = list(string)
}

variable "security_groups" {
  description = "List of security group IDs to associate with ECS tasks in awsvpc network mode. If not provided, an egress-only security group will be created."
  type        = list(string)
  default     = []
}

variable "vpc_id" {
  description = "VPC ID where security groups will be created (required only when security_groups is not provided)"
  type        = string
  default     = ""
}
