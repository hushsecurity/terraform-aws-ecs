locals {
  deployment_credentials_secret_arn         = var.deployment_credentials_secret_arn != null ? var.deployment_credentials_secret_arn : aws_secretsmanager_secret.deployment_credentials[0].arn
  container_registry_credentials_secret_arn = var.container_registry_credentials_secret_arn != null ? var.container_registry_credentials_secret_arn : aws_secretsmanager_secret.container_registry_credentials[0].arn
  deployment_credentials_secret_list = [
    {
      name      = "DEPLOYMENT_PASSWORD",
      valueFrom = "${local.deployment_credentials_secret_arn}:deployment_password::"
    },
    {
      name      = "DEPLOYMENT_TOKEN",
      valueFrom = "${local.deployment_credentials_secret_arn}:deployment_token::"
    }
  ]
}


module "hush_sensor" {
  count = var.enable_sensor ? 1 : 0

  source = "./modules/hush_sensor"

  cluster_name       = var.cluster_name
  execution_role_arn = aws_iam_role.hush_ecs_role.arn

  event_reporting_console = var.event_reporting_console
  trace_host              = var.trace_host
  trace_pods_default      = var.trace_pods_default
  report_tls              = var.report_tls
  cri_socket_path         = var.cri_socket_path
  docker_socket_path      = var.docker_socket_path
  akeyless_gateway_domain = var.akeyless_gateway_domain

  container_registry                        = var.container_registry
  deployment_credentials_secret_list        = local.deployment_credentials_secret_list
  container_registry_credentials_secret_arn = local.container_registry_credentials_secret_arn
}
