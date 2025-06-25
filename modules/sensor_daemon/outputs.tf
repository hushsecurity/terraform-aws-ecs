output "deployment_password_secret_arn" {
  description = "ARN of the deployment password secret (if created)"
  value       = try(aws_secretsmanager_secret.deployment_password[0].arn, null)
}

output "acr_credentials_secret_arn" {
  description = "ARN of the ACR credentials secret (if created)"
  value       = try(aws_secretsmanager_secret.acr_credentials[0].arn, null)
}

output "ecs_service_name" {
  description = "The name of the ECS service"
  value       = aws_ecs_service.sensor.name
}

output "ecs_service_arn" {
  description = "The full ARN of the ECS service"
  value       = aws_ecs_service.sensor.id
}

output "ecs_task_definition_arn" {
  description = "The full ARN of the ECS task definition"
  value       = aws_ecs_task_definition.sensor.arn
}
