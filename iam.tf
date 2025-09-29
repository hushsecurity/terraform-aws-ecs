data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_iam_role" "hush_ecs_execution_role" {
  name = "hush-ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "ecs-tasks.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "hush_ecs_execution_role_policy" {
  name = "hush-ecs-execution-role-policy"
  role = aws_iam_role.hush_ecs_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = ["secretsmanager:GetSecretValue"],
        Resource = [
          local.deployment_credentials_secret_arn,
          local.container_registry_credentials_secret_arn
        ]
      }
    ]
  })
}

resource "aws_iam_role" "hush_sensor_task_role" {
  count = var.enable_sensor ? 1 : 0
  name  = "hush-sensor-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "ecs-tasks.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role" "hush_vermon_task_role" {
  count = var.enable_vermon ? 1 : 0
  name  = "hush-vermon-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "ecs-tasks.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "hush_vermon_task_role_policy" {
  count = var.enable_vermon ? 1 : 0
  name  = "hush-vermon-task-role-policy"
  role  = aws_iam_role.hush_vermon_task_role[0].id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecs:UpdateService",
          "ecs:DescribeServices"
        ],
        Resource = compact([
          "arn:aws:ecs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:service/${var.cluster_name}/${var.sensor_service_name}",
          var.enable_vermon ? "arn:aws:ecs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:service/${var.cluster_name}/${var.vermon_service_name}" : ""
        ])
      },
      {
        Effect = "Allow",
        Action = [
          "ecs:DescribeClusters"
        ],
        Resource = [
          "arn:aws:ecs:*:*:cluster/${var.cluster_name}"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "ecs:DescribeTaskDefinition"
        ],
        Resource = compact([
          "arn:aws:ecs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:task-definition/${var.sensor_task_definition_family}:*",
          var.enable_vermon ? "arn:aws:ecs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:task-definition/${var.vermon_task_definition_family}:*" : ""
        ])
      },
      {
        Effect = "Allow",
        Action = [
          "ecs:ListServices"
        ],
        Resource = [
          "arn:aws:ecs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:cluster/${var.cluster_name}"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "ecs:ListTasks",
          "ecs:DescribeTasks"
        ],
        Resource = [
          "arn:aws:ecs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:cluster/${var.cluster_name}",
          "arn:aws:ecs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:task/${var.cluster_name}/*",
          "arn:aws:ecs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:container-instance/${var.cluster_name}/*"
        ]
      }
    ]
  })
}
