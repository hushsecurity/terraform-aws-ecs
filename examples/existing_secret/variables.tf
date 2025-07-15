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
