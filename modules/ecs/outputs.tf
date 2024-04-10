output "cluster_id" {
  description = "The ID of the created ECS cluster."
  value       = aws_ecs_cluster.ecs_cluster.id
}
output "cluster_name" {
  description = "The name of the created ECS cluster."
  value       = aws_ecs_cluster.ecs_cluster.name
}
output "cluster_arn" {
  description = "The ARN of the created ECS cluster."
  value       = aws_ecs_cluster.ecs_cluster.arn
}

output "ecs_service_name" {
  description = "The name of the ECS service"
  value       = aws_ecs_service.ecs_service.name
}
output "ecs_service_id" {
  description = "The name of the ECS service"
  value       = aws_ecs_service.ecs_service.id
}

output "task_definition_arn" {
  value = aws_ecs_task_definition.ecs_task_definition.arn
}
