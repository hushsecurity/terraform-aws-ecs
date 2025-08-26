output "sensor_service_name" {
  value       = module.hush_service.sensor_service_name
  description = "The sensor ECS service name"
}

output "sensor_service_arn" {
  value       = module.hush_service.sensor_service_arn
  description = "The sensor ECS service ARN"
}

output "sensor_task_definition_arn" {
  value       = module.hush_service.sensor_task_definition_arn
  description = "The sensor ECS task definition ARN"
}

output "vermon_service_name" {
  value       = module.hush_service.vermon_service_name
  description = "The Vermon ECS service name"
}

output "vermon_service_arn" {
  value       = module.hush_service.vermon_service_arn
  description = "The Vermon ECS service ARN"
}

output "vermon_task_definition_arn" {
  value       = module.hush_service.vermon_task_definition_arn
  description = "The Vermon ECS task definition ARN"
}

output "deployment_credentials_secret_arn" {
  value       = module.hush_service.deployment_credentials_secret_arn
  description = "ARN of the deployment password and token secret"
}

output "container_registry_credentials_secret_arn" {
  value       = module.hush_service.container_registry_credentials_secret_arn
  description = "ARN of the container registry credentials secret"
}
