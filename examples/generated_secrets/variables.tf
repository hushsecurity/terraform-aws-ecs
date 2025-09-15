# ─────────────────────────────────────────────
# Required core deployment configuration
# ─────────────────────────────────────────────
variable "cluster_name" {
  description = "Name of the ECS cluster to deploy into"
  type        = string

  validation {
    condition     = length(trim(var.cluster_name, " ")) > 0
    error_message = "The cluster_name must be non-empty."
  }
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

# ─────────────────────────────────────────────
# AWSVPC networking configuration
# ─────────────────────────────────────────────
variable "vpc_private_subnets" {
  description = "List of private subnet IDs for AWSVPC networking (must have NAT Gateway for internet access)"
  type        = list(string)
}

variable "security_groups" {
  description = "List of security group IDs for AWSVPC networking. If not provided, an egress-only security group will be created."
  type        = list(string)
  default     = []
}

variable "vpc_id" {
  description = "VPC ID where security groups will be created (required only when security_groups is not provided)"
  type        = string
  default     = ""
}
