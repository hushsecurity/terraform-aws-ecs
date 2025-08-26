output "sensor_service_name" {
  value       = module.hush_sensor[0].ecs_service_name
  description = "The sensor ECS service name"
}

output "sensor_service_arn" {
  value       = module.hush_sensor[0].ecs_service_arn
  description = "The sensor ECS service ARN"
}

output "sensor_task_definition_arn" {
  value       = module.hush_sensor[0].ecs_task_definition_arn
  description = "The sensor ECS task definition ARN"
}

output "sensor_task_definition_family" {
  value       = module.hush_sensor[0].task_definition_family
  description = "The sensor task definition family name"
}

output "sensor_task_family" {
  value       = module.hush_sensor[0].ecs_task_family
  description = "The sensor ECS task family name"
}

output "vermon_service_name" {
  value       = module.hush_vermon[0].ecs_service_name
  description = "The Vermon ECS service name"
}

output "vermon_service_arn" {
  value       = module.hush_vermon[0].ecs_service_arn
  description = "The Vermon ECS service ARN"
}

output "vermon_task_definition_arn" {
  value       = module.hush_vermon[0].ecs_task_definition_arn
  description = "The Vermon ECS task definition ARN"
}

output "vermon_task_definition_family" {
  value       = module.hush_vermon[0].task_definition_family
  description = "The vermon task definition family name"
}

output "vermon_task_family" {
  value       = module.hush_vermon[0].ecs_task_family
  description = "The vermon ECS task family name"
}

output "manage_task_families" {
  value       = local.manage_task_families
  description = "Comma-separated list of task families used for Hush namespace-equivalent logic"
}

output "deployment_credentials_secret_arn" {
  value       = local.deployment_credentials_secret_arn
  description = "ARN of the deployment password and token secret"
}

output "container_registry_credentials_secret_arn" {
  value       = local.container_registry_credentials_secret_arn
  description = "ARN of the container registry credentials secret"
}
