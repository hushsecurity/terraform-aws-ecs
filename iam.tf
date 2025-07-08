resource "aws_iam_role" "hush_ecs_role" {
  name = "hush-ecs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "ecs-tasks.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "hush_ecs_role_policy" {
  name = "hush-ecs-role-policy"
  role = aws_iam_role.hush_ecs_role.id

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
