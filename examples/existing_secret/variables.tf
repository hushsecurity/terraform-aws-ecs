variable "cluster_name" {
  description = "Name of the ECS cluster to deploy into"
  type        = string
}

variable "deployment_credentials_secret_arn" {
  description = "ARN of AWS Secrets Manager secret containing deployment credentials (JSON with deployment_token and deployment_password)"
  type        = string
}

variable "container_registry_credentials_secret_arn" {
  description = "ARN of AWS Secrets Manager secret containing container registry credentials (JSON with username and password)"
  type        = string
}

variable "vpc_private_subnets" {
  description = "List of private subnet IDs (must have NAT Gateway for internet access)"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID where security group will be created"
  type        = string
}
