resource "aws_iam_role" "sensor_exec" {
  name = "${var.service_name}-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "ecs-tasks.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })

  tags = {
    Service   = var.service_name
    ManagedBy = "terraform"
  }
}

resource "aws_iam_role_policy" "sensor_exec_policy" {
  name = "${var.service_name}-exec-policy"
  role = aws_iam_role.sensor_exec.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "secretsmanager:GetSecretValue"
        ],
        Resource = "*"
      }
    ]
  })
}
