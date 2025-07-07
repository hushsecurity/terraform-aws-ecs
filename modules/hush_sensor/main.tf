resource "aws_ecs_task_definition" "hush_sensor_task_definition" {
  family                   = "hush-sensor-service"
  requires_compatibilities = ["EC2"]
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
      environment = [
        { name = "DEPLOYMENT_KIND", value = "ecs" },
        { name = "CRI_SOCKET_PATH", value = var.cri_socket_path },
        { name = "EVENT_REPORTING_CONSOLE", value = var.event_reporting_console },
        { name = "TRACE_HOST", value = tostring(var.trace_host) },
        { name = "TRACE_PODS_DEFAULT", value = tostring(var.trace_pods_default) },
        { name = "REPORT_TLS", value = tostring(var.report_tls) },
        { name = "AKEYLESS_GATEWAY_DOMAIN", value = tostring(var.akeyless_gateway_domain) }
      ],
      secrets = var.deployment_credentials_secret_list,
      mountPoints = [
        { sourceVolume = "docker_sock", containerPath = "/var/run/docker.sock", readOnly = true },
        { sourceVolume = "containerd_sock", containerPath = "/var/run/containerd/containerd.sock", readOnly = true },
        { sourceVolume = "host_cgroup", containerPath = "/hostcgroup", readOnly = true },
        { sourceVolume = "vector", containerPath = "/tmp/vector" }
      ],
      repositoryCredentials = {
        credentialsParameter = var.container_registry_credentials_secret_arn
      }
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
        { name = "EVENT_REPORTING_CONSOLE", value = var.event_reporting_console },
        { name = "REPORT_TLS", value = tostring(var.report_tls) }
      ],
      secrets = var.deployment_credentials_secret_list,
      mountPoints = [
        { sourceVolume = "vector", containerPath = "/tmp/vector" }
      ],
      repositoryCredentials = {
        credentialsParameter = var.container_registry_credentials_secret_arn
      }
    }
  ])

  volume {
    name      = "docker_sock"
    host_path = "/var/run/docker.sock"
  }

  volume {
    name      = "containerd_sock"
    host_path = "/var/run/containerd/containerd.sock"
  }

  volume {
    name      = "host_cgroup"
    host_path = "/sys/fs/cgroup"
  }

  volume {
    name      = "vector"
    host_path = "/tmp/vector"
  }
}

resource "aws_ecs_service" "hush_sensor_service" {
  name                = "hush-sensor-daemon"
  cluster             = var.cluster_name
  launch_type         = "EC2"
  scheduling_strategy = "DAEMON"
  task_definition     = aws_ecs_task_definition.hush_sensor_task_definition.arn
}
