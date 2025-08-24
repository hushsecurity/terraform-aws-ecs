output "ecs_service_name" {
  value       = aws_ecs_service.hush_sensor_service.name
  description = "The name of the ECS service"
}

output "ecs_service_arn" {
  value       = aws_ecs_service.hush_sensor_service.id
  description = "The full ARN of the ECS service"
}

output "ecs_task_definition_arn" {
  value       = aws_ecs_task_definition.hush_sensor_task_definition.arn
  description = "The full ARN of the ECS task definition"
}

output "task_definition_family" {
  value       = local.task_family
  description = "The task definition family name"
}

output "ecs_task_family" {
  value       = aws_ecs_task_definition.hush_sensor_task_definition.family
  description = "The task family name for the sensor"
}
