output "deployment_password_secret_arn" {
  value       = module.sensor_daemon.deployment_password_secret_arn
  description = "ARN of deployment_password (if created)"
}

output "acr_credentials_secret_arn" {
  value       = module.sensor_daemon.acr_credentials_secret_arn
  description = "ARN of ACR credentials secret (if created)"
}

output "ecs_service_name" {
  value       = module.sensor_daemon.ecs_service_name
  description = "The name of the ECS service"
}

output "ecs_service_arn" {
  value       = module.sensor_daemon.ecs_service_arn
  description = "The full ARN of the ECS service"
}

output "ecs_task_definition_arn" {
  value       = module.sensor_daemon.ecs_task_definition_arn
  description = "The full ARN of the ECS task definition"
}
