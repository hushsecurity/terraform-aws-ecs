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
