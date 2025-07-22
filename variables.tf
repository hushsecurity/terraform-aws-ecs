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
