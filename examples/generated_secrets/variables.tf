variable "cluster_name" {
  description = "Name of the ECS cluster to deploy into"
  type        = string
}

variable "deployment_token" {
  description = "Deployment token for Hush service authentication"
  type        = string
  sensitive   = true
}

variable "deployment_password" {
  description = "Deployment password for Hush service authentication"
  type        = string
  sensitive   = true
}

variable "container_registry_username" {
  description = "Username for container registry authentication"
  type        = string
}

variable "container_registry_password" {
  description = "Password for container registry authentication"
  type        = string
  sensitive   = true
}

variable "vpc_private_subnets" {
  description = "List of private subnet IDs (must have NAT Gateway for internet access)"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID where security group will be created"
  type        = string
}
