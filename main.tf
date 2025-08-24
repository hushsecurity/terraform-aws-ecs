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

  sensor_image_repo        = var.sensor_image_repo
  sensor_vector_image_repo = var.sensor_vector_image_repo
  sensor_tag               = var.sensor_tag
}

module "hush_vermon" {
  count = var.enable_vermon && var.enable_sensor ? 1 : 0

  source = "./modules/hush_vermon"

  cluster_name         = var.cluster_name
  execution_role_arn   = aws_iam_role.hush_ecs_role.arn
  vermon_task_role_arn = aws_iam_role.hush_vermon_role[0].arn
  sensor_service_name  = module.hush_sensor[0].ecs_service_name

  deployment_name = var.cluster_name

  event_reporting_console = var.event_reporting_console
  vermon_update_frequency = var.vermon_update_frequency

  container_registry                        = var.container_registry
  deployment_credentials_secret_list        = local.deployment_credentials_secret_list
  container_registry_credentials_secret_arn = local.container_registry_credentials_secret_arn

  vermon_image_repo        = var.vermon_image_repo
  sensor_vector_image_repo = var.sensor_vector_image_repo
  sensor_tag               = var.sensor_tag
}
