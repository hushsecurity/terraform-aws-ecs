# ─────────────────────────────────────────────
# Required core deployment configuration
# ─────────────────────────────────────────────
variable "task_definition_family" {
  description = "Name of the ECS task definition family for this vermon service"
  type        = string
}

variable "service_name" {
  description = "Name of the ECS service for this vermon"
  type        = string
  default     = "hush-vermon"
}

variable "deployment_name" {
  description = "Name/identifier for this deployment instance"
  type        = string
}

variable "deployment_tags" {
  description = "Tags to identify services belonging to this deployment"
  type        = map(string)
  default     = {}
}

# ─────────────────────────────────────────────
# Container identification - using task definition families
# ─────────────────────────────────────────────
variable "manage_task_families" {
  description = "Comma-separated list of ECS task definition families that vermon should manage and update"
  type        = string
}

variable "cluster_name" {
  description = "Name of the ECS cluster to deploy into"
  type        = string

  validation {
    condition     = length(trim(var.cluster_name, " ")) > 0
    error_message = "The 'cluster_name' value is required and cannot be empty"
  }
}

variable "container_registry" {
  description = "Container registry hostname"
  type        = string
  default     = "hushsecurity.azurecr.io"
}

variable "vermon_image_repo" {
  description = "Repository name for the vermon container"
  type        = string
  default     = "vermon"
}

variable "vermon_vector_image_repo" {
  description = "Repository name for the vector sidecar container"
  type        = string
  default     = "sensor-vector"
}

variable "vermon_tag" {
  description = "Tag to use for images shared across components"
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

variable "vermon_update_frequency" {
  description = "How often Vermon checks for updates (e.g., '8h', '5m')"
  type        = string
  default     = "8h"
}

# ─────────────────────────────────────────────
# ECS Task sizing
# ─────────────────────────────────────────────
variable "vermon_container_memory" {
  description = "Memory in MiB to allocate to Vermon container"
  type        = number
  default     = 256
}

variable "vermon_container_memory_reservation" {
  description = "Memory reservation in MiB for Vermon container"
  type        = number
  default     = 64
}

variable "vermon_vector_container_memory" {
  description = "Memory in MiB to allocate to Vermon Vector container"
  type        = number
  default     = 128
}

variable "vermon_vector_container_memory_reservation" {
  description = "Memory reservation in MiB for Vermon Vector container"
  type        = number
  default     = 32
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

variable "vermon_task_role_arn" {
  description = "IAM role ARN used by Vermon for ECS operations"
  type        = string
}

variable "deployment_credentials_secret_list" {
  description = "List of deployment credentials to inject into services"
  type        = list(map(string))
}

# ─────────────────────────────────────────────
# AWSVPC Network Configuration
# ─────────────────────────────────────────────
variable "subnet_ids" {
  description = "List of subnet IDs for AWSVPC networking mode"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs for AWSVPC networking mode"
  type        = list(string)
}
