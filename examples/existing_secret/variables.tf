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

variable "container_registry_credentials_secret_arn" {
  description = "Existing ARN for container registry credentials secret (optional)"
  type        = string
  default     = null
}

# ─────────────────────────────────────────────
# Deployment credentials
# ─────────────────────────────────────────────
variable "deployment_credentials_secret_arn" {
  description = "If provided, deployment_token and deployment_password variables are ignored. The secret must be a JSON object with the fields \"deployment_token\" and \"deployment_password\"."
  type        = string
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
