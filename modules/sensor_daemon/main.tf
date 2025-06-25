# === Locals ===
locals {
  deployment_password_secret_arn = (
    var.deployment_password_arn != null || var.deployment_password != null
    ) ? try(
    var.deployment_password_arn,
    aws_secretsmanager_secret.deployment_password[0].arn
  ) : error("Missing both deployment_password and deployment_password_arn")

  acr_credentials_secret_arn = (
    var.acr_credentials_secret_arn != null || var.acr_password != null
    ) ? try(
    var.acr_credentials_secret_arn,
    aws_secretsmanager_secret.acr_credentials[0].arn
  ) : null
}

# === Random Suffix ===
resource "random_string" "suffix" {
  length  = 5
  special = false
}

# === Optional Secret Creation ===
resource "aws_secretsmanager_secret" "acr_credentials" {
  count       = var.acr_credentials_secret_arn == null && var.acr_password != null ? 1 : 0
  name        = "${var.service_name}-acr-credentials-${random_string.suffix.result}"
  description = "ACR credentials for image pull"
}

resource "aws_secretsmanager_secret_version" "acr_credentials_version" {
  count         = var.acr_credentials_secret_arn == null && var.acr_password != null ? 1 : 0
  secret_id     = aws_secretsmanager_secret.acr_credentials[0].id
  secret_string = jsonencode({ username = var.acr_username, password = var.acr_password })
}

resource "aws_secretsmanager_secret" "deployment_password" {
  count       = var.deployment_password_arn == null && var.deployment_password != null ? 1 : 0
  name        = "${var.service_name}-deployment-password-${random_string.suffix.result}"
  description = "Sensor deployment password"
}

resource "aws_secretsmanager_secret_version" "deployment_password_version" {
  count         = var.deployment_password_arn == null && var.deployment_password != null ? 1 : 0
  secret_id     = aws_secretsmanager_secret.deployment_password[0].id
  secret_string = var.deployment_password
}

# === ECS Task Definition ===
resource "aws_ecs_task_definition" "sensor" {
  family                   = "sensor-task"
  requires_compatibilities = ["EC2"]
  pid_mode                 = "host"
  execution_role_arn       = aws_iam_role.sensor_exec.arn
  cpu                      = var.task_cpu
  memory                   = var.task_memory

  container_definitions = jsonencode([
    merge({
      name       = "sensor"
      image      = "${var.acr_registry}/${var.sensor_image_repo}:${var.image_tag}"
      essential  = true
      privileged = true
      cpu        = 0
      linuxParameters = {
        initProcessEnabled = true
        capabilities       = { add = ["ALL"] }
      }
      environment = [
        { name = "LOG_REPORTING_ENDPOINT", value = var.log_reporting_uri },
        { name = "DEPLOYMENT_TOKEN", value = var.deployment_token },
        { name = "EVENT_REPORTING_ENDPOINT", value = var.event_reporting_uri },
        { name = "EVENT_REPORTING_CONSOLE", value = var.event_reporting_console },
        { name = "TRACE_HOST", value = var.trace_host },
        { name = "TRACE_PODS_DEFAULT", value = var.trace_pods_default },
        { name = "REPORT_TLS", value = var.report_tls },
        { name = "CRI_SOCKET_PATH", value = var.cri_socket_path },
        { name = "AKEYLESS_GATEWAY_DOMAIN", value = var.akeyless_gateway_domain }

      ]
      secrets = can(local.deployment_password_secret_arn) && local.deployment_password_secret_arn != null ? [
        {
          name      = "EVENT_REPORTING_TOKEN",
          valueFrom = local.deployment_password_secret_arn
        }
      ] : []
      mountPoints = [
        { sourceVolume = "docker_sock", containerPath = "/var/run/docker.sock", readOnly = true },
        { sourceVolume = "containerd_sock", containerPath = "/var/run/containerd/containerd.sock", readOnly = true },
        { sourceVolume = "host_cgroup", containerPath = "/hostcgroup", readOnly = true },
        { sourceVolume = "vector-tmp", containerPath = "/tmp/vector" }
      ]
      }, local.acr_credentials_secret_arn != null ? {
      repositoryCredentials = {
        credentialsParameter = local.acr_credentials_secret_arn
      }
    } : {}),

    merge({
      name       = "sensor-vector"
      image      = "${var.acr_registry}/${var.sensor_vector_image_repo}:${var.image_tag}"
      essential  = true
      privileged = true
      cpu        = 0
      linuxParameters = {
        initProcessEnabled = true
        capabilities       = { add = ["ALL"] }
      }
      environment = [
        { name = "LOG_REPORTING_ENDPOINT", value = var.log_reporting_uri },
        { name = "DEPLOYMENT_TOKEN", value = var.deployment_token },
        { name = "EVENT_REPORTING_ENDPOINT", value = var.event_reporting_uri },
        { name = "EVENT_REPORTING_CONSOLE", value = var.event_reporting_console },
        { name = "EVENT_REPORTING_CONSOLE_PRETTY", value = var.event_reporting_console_pretty },
        { name = "TRACE_HOST", value = var.trace_host },
        { name = "TRACE_PODS_DEFAULT", value = var.trace_pods_default },
        { name = "REPORT_TLS", value = var.report_tls },
        { name = "CRI_SOCKET_PATH", value = var.cri_socket_path },
        { name = "AKEYLESS_GATEWAY_DOMAIN", value = var.akeyless_gateway_domain }

      ]
      secrets = can(local.deployment_password_secret_arn) && local.deployment_password_secret_arn != null ? [
        {
          name      = "EVENT_REPORTING_TOKEN",
          valueFrom = local.deployment_password_secret_arn
        }
      ] : []
      mountPoints = [
        { sourceVolume = "vector-tmp", containerPath = "/tmp/vector" }
      ]
      }, local.acr_credentials_secret_arn != null ? {
      repositoryCredentials = {
        credentialsParameter = local.acr_credentials_secret_arn
      }
    } : {})
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
    name      = "vector-tmp"
    host_path = "/tmp/vector"
  }
}

# === ECS Service ===
resource "aws_ecs_service" "sensor" {
  name                = var.service_name
  cluster             = var.cluster_name
  launch_type         = "EC2"
  scheduling_strategy = "DAEMON"
  task_definition     = aws_ecs_task_definition.sensor.arn
}
