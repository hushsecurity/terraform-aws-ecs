locals {
  # ECS resource names and values
  task_family  = var.task_definition_family
  service_name = var.service_name
  launch_type  = "EC2"
}

# Data sources for AWS region
data "aws_region" "current" {}

resource "aws_ecs_task_definition" "hush_vermon_task_definition" {
  family                   = local.task_family
  requires_compatibilities = [local.launch_type]
  network_mode             = "awsvpc"
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.vermon_task_role_arn

  container_definitions = jsonencode([
    {
      name              = "hush-vermon",
      image             = "${var.container_registry}/${var.vermon_image_repo}:${var.vermon_tag}",
      essential         = true,
      memory            = var.vermon_container_memory,
      memoryReservation = var.vermon_container_memory_reservation,
      linuxParameters = {
        initProcessEnabled = true
      },
      secrets = var.deployment_credentials_secret_list,
      repositoryCredentials = {
        credentialsParameter = var.container_registry_credentials_secret_arn
      },
      environment = [
        { name = "AWS_REGION", value = data.aws_region.current.name },
        { name = "DEPLOYMENT_KIND", value = "ecs" },
        { name = "MANAGE_TASK_FAMILIES", value = var.manage_task_families },
        { name = "ECS_CLUSTER", value = var.cluster_name },
        { name = "SELF_ECS_TASK_FAMILY", value = local.task_family },
        { name = "ECS_LAUNCH_TYPE", value = local.launch_type },
        { name = "CHANNEL_DIGESTS_PERIOD", value = var.vermon_update_frequency },
        { name = "CONTAINER_REGISTRY", value = var.container_registry },
        { name = "DEPLOYMENT_NAME", value = var.deployment_name },
        { name = "DEPLOYMENT_TAGS", value = jsonencode(var.deployment_tags) }
      ],
      mountPoints = [
        { sourceVolume = "vector-socket", containerPath = "/tmp/vector" },
        { sourceVolume = "host-dir", containerPath = "/var/lib/hush-security" }
      ]
    },
    {
      name              = "hush-vermon-vector",
      image             = "${var.container_registry}/${var.vermon_vector_image_repo}:${var.vermon_tag}",
      essential         = true,
      memory            = var.vermon_vector_container_memory,
      memoryReservation = var.vermon_vector_container_memory_reservation,
      linuxParameters = {
        initProcessEnabled = true
      },
      environment = [
        { name = "AWS_REGION", value = data.aws_region.current.name },
        { name = "DEPLOYMENT_KIND", value = "ecs" },
        { name = "ECS_CLUSTER", value = var.cluster_name },
        { name = "ECS_SERVICE", value = local.service_name },
        { name = "ECS_TASK_DEFINITION", value = local.task_family },
        { name = "ECS_LAUNCH_TYPE", value = local.launch_type },
        { name = "EVENT_REPORTING_CONSOLE", value = var.event_reporting_console }
      ],
      secrets = var.deployment_credentials_secret_list,
      repositoryCredentials = {
        credentialsParameter = var.container_registry_credentials_secret_arn
      },
      mountPoints = [
        { sourceVolume = "vector-socket", containerPath = "/tmp/vector" }
      ]
    }
  ])

  volume {
    name = "vector-socket"
  }

  volume {
    name      = "host-dir"
    host_path = "/var/lib/hush-security"
  }
}

resource "aws_ecs_service" "hush_vermon_service" {
  name            = local.service_name
  cluster         = var.cluster_name
  launch_type     = local.launch_type
  task_definition = aws_ecs_task_definition.hush_vermon_task_definition.arn
  desired_count   = 1 # Single instance for cluster-wide operations

  network_configuration {
    subnets         = var.subnet_ids
    security_groups = var.security_group_ids
  }
}
