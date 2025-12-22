output "sensor_service_name" {
  value       = try(module.hush_ecs.sensor_service_name, null)
  description = "The sensor ECS service name"
}

output "sensor_service_arn" {
  value       = try(module.hush_ecs.sensor_service_arn, null)
  description = "The sensor ECS service ARN"
}

output "vermon_service_name" {
  value       = try(module.hush_ecs.vermon_service_name, null)
  description = "The Vermon ECS service name"
}

output "vermon_service_arn" {
  value       = try(module.hush_ecs.vermon_service_arn, null)
  description = "The Vermon ECS service ARN"
}

output "deployment_credentials_secret_arn" {
  value       = module.hush_ecs.deployment_credentials_secret_arn
  description = "ARN of the deployment credentials secret"
}

output "container_registry_credentials_secret_arn" {
  value       = module.hush_ecs.container_registry_credentials_secret_arn
  description = "ARN of the container registry credentials secret"
}
