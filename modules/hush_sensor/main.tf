locals {
  task_family  = var.task_definition_family
  service_name = var.service_name
  launch_type  = "EC2"
}

resource "aws_ecs_task_definition" "hush_sensor_task_definition" {
  family                   = local.task_family
  requires_compatibilities = [local.launch_type]
  pid_mode                 = "host"
  execution_role_arn       = var.execution_role_arn

  container_definitions = jsonencode([
    {
      name              = "sensor",
      image             = "${var.container_registry}/${var.sensor_image_repo}:${var.sensor_tag}",
      essential         = true,
      privileged        = true,
      memory            = var.sensor_container_memory,
      memoryReservation = var.sensor_container_memory_reservation,
      linuxParameters = {
        initProcessEnabled = true,
        capabilities       = { add = ["ALL"] }
      },
      secrets = var.deployment_credentials_secret_list,
      repositoryCredentials = {
        credentialsParameter = var.container_registry_credentials_secret_arn
      },
      environment = concat([
        { name = "DEPLOYMENT_KIND", value = "ecs" },
        { name = "EXCLUDE_TASK_FAMILIES", value = var.exclude_task_families },
        { name = "ECS_CLUSTER", value = var.cluster_name },
        { name = "ECS_SERVICE", value = local.service_name },
        { name = "SELF_ECS_TASK_FAMILY", value = local.task_family },
        { name = "ECS_LAUNCH_TYPE", value = local.launch_type },
        { name = "TRACE_HOST", value = tostring(var.trace_host) },
        { name = "TRACE_PODS_DEFAULT", value = tostring(var.trace_pods_default) },
        { name = "REPORT_TLS", value = tostring(var.report_tls) },
        { name = "AKEYLESS_GATEWAY_DOMAIN", value = tostring(var.akeyless_gateway_domain) },
        { name = "EVENT_REPORTING_CONSOLE", value = var.event_reporting_console }
        ],
        var.cri_socket_path != null && var.cri_socket_path != "" ?
      [{ name = "CRI_SOCKET_PATH", value = var.cri_socket_path }] : []),
      mountPoints = concat([
        { sourceVolume = "cgroupfs", containerPath = "/hostcgroup", readOnly = true },
        { sourceVolume = "vector-socket", containerPath = "/tmp/vector" },
        { sourceVolume = "host-dir", containerPath = "/var/lib/hush-security" },
        ],
        var.docker_socket_path != null && var.docker_socket_path != "" ?
        [{ sourceVolume = "docker-socket", containerPath = dirname(var.docker_socket_path), readOnly = true }] : [],
        var.cri_socket_path != null && var.cri_socket_path != "" ?
      [{ sourceVolume = "cri-socket", containerPath = dirname(var.cri_socket_path), readOnly = true }] : [])
    },
    {
      name              = "sensor-vector",
      image             = "${var.container_registry}/${var.sensor_vector_image_repo}:${var.sensor_tag}",
      essential         = true,
      memory            = var.sensor_vector_container_memory,
      memoryReservation = var.sensor_vector_container_memory_reservation,
      linuxParameters = {
        initProcessEnabled = true,
        capabilities       = { add = ["ALL"] }
      },
      environment = [
        { name = "DEPLOYMENT_KIND", value = "ecs" },
        { name = "ECS_CLUSTER", value = var.cluster_name },
        { name = "ECS_SERVICE", value = local.service_name },
        { name = "ECS_TASK_DEFINITION", value = local.task_family },
        { name = "ECS_LAUNCH_TYPE", value = local.launch_type },
        { name = "EVENT_REPORTING_CONSOLE", value = var.event_reporting_console },
        { name = "REPORT_TLS", value = tostring(var.report_tls) }
      ],
      secrets = var.deployment_credentials_secret_list,
      mountPoints = [
        { sourceVolume = "vector-socket", containerPath = "/tmp/vector" }
      ],
      repositoryCredentials = {
        credentialsParameter = var.container_registry_credentials_secret_arn
      }
    }
  ])

  dynamic "volume" {
    for_each = var.docker_socket_path != null && var.docker_socket_path != "" ? [1] : []
    content {
      name      = "docker-socket"
      host_path = dirname(var.docker_socket_path)
    }
  }

  dynamic "volume" {
    for_each = var.cri_socket_path != null && var.cri_socket_path != "" ? [1] : []
    content {
      name      = "cri-socket"
      host_path = dirname(var.cri_socket_path)
    }
  }

  volume {
    name = "vector-socket"
  }

  volume {
    name      = "cgroupfs"
    host_path = "/sys/fs/cgroup"
  }

  volume {
    name      = "host-dir"
    host_path = "/var/lib/hush-security"
  }

}

resource "aws_ecs_service" "hush_sensor_service" {
  name                = local.service_name
  cluster             = var.cluster_name
  launch_type         = local.launch_type
  scheduling_strategy = "DAEMON"
  task_definition     = aws_ecs_task_definition.hush_sensor_task_definition.arn
}
