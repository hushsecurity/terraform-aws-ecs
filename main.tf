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

  # Centralized task family definitions - this is the single source of truth
  # When adding new modules, add their task family names here
  task_families = {
    sensor = var.sensor_task_definition_family
    vermon = var.vermon_task_definition_family
  }

  # Map of all module enable flags - matches task_families keys
  # Add corresponding var.enable_* variables when adding new modules
  module_enable_flags = {
    sensor = var.enable_sensor
    vermon = var.enable_vermon
  }

  # Build list of task families for Hush namespace-equivalent logic
  manage_task_families_list = [
    for module_name, task_family in local.task_families :
    task_family if local.module_enable_flags[module_name]
  ]

  manage_task_families = join(",", local.manage_task_families_list)
}


module "hush_sensor" {
  count = var.enable_sensor ? 1 : 0

  source = "./modules/hush_sensor"

  task_definition_family = local.task_families.sensor
  service_name           = var.sensor_service_name
  cluster_name           = var.cluster_name
  execution_role_arn     = aws_iam_role.hush_ecs_execution_role.arn
  task_role_arn          = aws_iam_role.hush_sensor_task_role[0].arn

  exclude_task_families = local.manage_task_families

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

  subnet_ids         = var.vpc_private_subnets
  security_group_ids = var.security_groups
}

module "hush_vermon" {
  count = var.enable_vermon ? 1 : 0

  source = "./modules/hush_vermon"

  task_definition_family = local.task_families.vermon
  service_name           = var.vermon_service_name
  cluster_name           = var.cluster_name
  execution_role_arn     = aws_iam_role.hush_ecs_execution_role.arn
  vermon_task_role_arn   = aws_iam_role.hush_vermon_task_role[0].arn

  deployment_name      = var.cluster_name
  manage_task_families = local.manage_task_families

  event_reporting_console = var.event_reporting_console
  vermon_update_frequency = var.vermon_update_frequency

  container_registry                        = var.container_registry
  deployment_credentials_secret_list        = local.deployment_credentials_secret_list
  container_registry_credentials_secret_arn = local.container_registry_credentials_secret_arn

  vermon_image_repo        = var.vermon_image_repo
  vermon_vector_image_repo = var.sensor_vector_image_repo
  vermon_tag               = var.sensor_tag

  subnet_ids         = var.vpc_private_subnets
  security_group_ids = var.security_groups
}
