terraform {
  required_version = ">= 1.3"
}

module "hush_service" {
  source  = "hushsecurity/ecs/aws"
  version = "~> 1.0"

  cluster_name       = var.cluster_name
  container_registry = var.container_registry

  deployment_credentials_secret_arn         = var.deployment_credentials_secret_arn
  container_registry_credentials_secret_arn = var.container_registry_credentials_secret_arn
}
