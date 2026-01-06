# ─────────────────────────────────────────────
# Required core deployment configuration
# ─────────────────────────────────────────────
variable "task_definition_family" {
  description = "Name of the ECS task definition family for this sensor service"
  type        = string
}

variable "service_name" {
  description = "Name of the ECS service for this sensor"
  type        = string
  default     = "hush-sensor-daemon"
}

variable "cluster_name" {
  description = "Name of the ECS cluster to deploy into"
  type        = string

  validation {
    condition     = length(trim(var.cluster_name, " ")) > 0
    error_message = "The 'cluster_name' value is required and cannot be empty"
  }
}

# ─────────────────────────────────────────────
# Container identification
# ─────────────────────────────────────────────
variable "exclude_task_families" {
  description = "Comma-separated list of ECS task definition families that sensor should exclude from scanning"
  type        = string
}

variable "container_registry" {
  description = "Container registry hostname"
  type        = string
  default     = "hushsecurity.azurecr.io"
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

variable "sensor_tag" {
  description = "Tag to use for sensor container images"
  type        = string
  default     = "v0"
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

variable "enable_java_probing" {
  description = "Enable Java probing in the sensor"
  type        = bool
  default     = true
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
# ECS Task sizing
# ─────────────────────────────────────────────
variable "sensor_container_memory" {
  description = "Memory in MiB to allocate to ECS task"
  type        = number
  default     = 1024
}

variable "sensor_container_memory_reservation" {
  description = "Memory in MiB to allocate to ECS task"
  type        = number
  default     = 256
}

variable "sensor_vector_container_memory" {
  description = "Memory in MiB to allocate to ECS task"
  type        = number
  default     = 256
}

variable "sensor_vector_container_memory_reservation" {
  description = "Memory in MiB to allocate to ECS task"
  type        = number
  default     = 64
}

# ─────────────────────────────────────────────
# Secret ARNs and credentials — injected from root via locals
# ─────────────────────────────────────────────
variable "container_registry_credentials_secret_arn" {
  description = "ARN of the container registry secret"
  type        = string
}

variable "execution_role_arn" {
  description = "IAM role ARN used by ECS task execution"
  type        = string
}

variable "task_role_arn" {
  description = "IAM role ARN used by running tasks for AWS API calls"
  type        = string
  default     = null
}

variable "deployment_credentials_secret_list" {
  description = "List of deployment credentials to inject into services"
  type        = list(map(string))
}

# ─────────────────────────────────────────────
# Network configuration for awsvpc mode
# ─────────────────────────────────────────────
variable "subnet_ids" {
  description = "List of subnet IDs where tasks will be placed"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs to associate with tasks"
  type        = list(string)
}
