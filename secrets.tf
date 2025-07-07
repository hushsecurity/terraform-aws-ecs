resource "aws_secretsmanager_secret" "deployment_credentials" {
  count       = var.deployment_credentials_secret_arn == null ? 1 : 0
  name_prefix = "hush-deployment-credentials-"
  description = "Hush Security deployment token and password"
}

resource "aws_secretsmanager_secret_version" "deployment_credentials_version" {
  count     = var.deployment_credentials_secret_arn == null ? 1 : 0
  secret_id = aws_secretsmanager_secret.deployment_credentials[0].id
  secret_string = jsonencode({
    deployment_token    = var.deployment_token,
    deployment_password = var.deployment_password
  })
}

resource "aws_secretsmanager_secret" "container_registry_credentials" {
  count       = var.container_registry_credentials_secret_arn == null ? 1 : 0
  name_prefix = "hush-container-registry-credentials-"
  description = "Hush Security container registry credentials"
}

resource "aws_secretsmanager_secret_version" "container_registry_credentials_version" {
  count     = var.container_registry_credentials_secret_arn == null ? 1 : 0
  secret_id = aws_secretsmanager_secret.container_registry_credentials[0].id
  secret_string = jsonencode({
    username = var.container_registry_username,
    password = var.container_registry_password
  })
}
