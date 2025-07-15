output "ecs_service_name" {
  value       = module.hush_service.ecs_service_name
  description = "The ECS service name"
}

output "ecs_service_arn" {
  value       = module.hush_service.ecs_service_arn
  description = "The ECS service ARN"
}

output "ecs_task_definition_arn" {
  value       = module.hush_service.ecs_task_definition_arn
  description = "The ECS task definition ARN"
}
