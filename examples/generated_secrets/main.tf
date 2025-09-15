terraform {
  required_version = ">= 1.3"
}

module "hush_service" {
  source = "../../"

  cluster_name       = var.cluster_name
  container_registry = var.container_registry

  deployment_password = var.deployment_password
  deployment_token    = var.deployment_token

  container_registry_username = var.container_registry_username
  container_registry_password = var.container_registry_password

  vpc_private_subnets = var.vpc_private_subnets
  security_groups     = var.security_groups
  vpc_id              = var.vpc_id
}
