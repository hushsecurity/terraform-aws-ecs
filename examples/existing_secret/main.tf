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

  # Existing Secrets Manager ARNs
  deployment_credentials_secret_arn         = var.deployment_credentials_secret_arn
  container_registry_credentials_secret_arn = var.container_registry_credentials_secret_arn

  # Networking
  vpc_private_subnets = var.vpc_private_subnets
  vpc_id              = var.vpc_id
}
