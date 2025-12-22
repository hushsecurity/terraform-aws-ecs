terraform {
  required_version = ">= 1.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

module "hush_ecs" {
  source  = "hushsecurity/ecs/aws"
  version = "~> 1.0" # Find the latest version at https://registry.terraform.io/modules/hushsecurity/ecs/aws/latest

  cluster_name = var.cluster_name

  # Module will create secrets from these values
  deployment_token    = var.deployment_token
  deployment_password = var.deployment_password

  container_registry_username = var.container_registry_username
  container_registry_password = var.container_registry_password

  # Networking
  vpc_private_subnets = var.vpc_private_subnets
  vpc_id              = var.vpc_id
}
