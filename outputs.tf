output "ecs_service_name" {
  value       = module.hush_sensor[0].ecs_service_name
  description = "The ECS service name"
}

output "ecs_service_arn" {
  value       = module.hush_sensor[0].ecs_service_arn
  description = "The ECS service ARN"
}

output "ecs_task_definition_arn" {
  value       = module.hush_sensor[0].ecs_task_definition_arn
  description = "The ECS task definition ARN"
}

output "deployment_credentials_secret_arn" {
  value       = local.deployment_credentials_secret_arn
  description = "ARN of the deployment password and token secret"
}

output "container_registry_credentials_secret_arn" {
  value       = local.container_registry_credentials_secret_arn
  description = "ARN of the container registry credentials secret"
}
