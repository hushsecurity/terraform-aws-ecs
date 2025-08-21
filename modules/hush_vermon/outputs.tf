output "ecs_service_name" {
  value       = aws_ecs_service.hush_vermon_service.name
  description = "The name of the Vermon ECS service"
}

output "ecs_service_arn" {
  value       = aws_ecs_service.hush_vermon_service.id
  description = "The full ARN of the Vermon ECS service"
}

output "ecs_task_definition_arn" {
  value       = aws_ecs_task_definition.hush_vermon_task_definition.arn
  description = "The full ARN of the Vermon ECS task definition"
}

output "task_definition_family" {
  value       = local.task_family
  description = "The task definition family name"
}

output "ecs_task_family" {
  value       = aws_ecs_task_definition.hush_vermon_task_definition.family
  description = "The task family name for the vermon"
}
