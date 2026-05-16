output "autoscaling_target_id" {
  value = aws_appautoscaling_target.ecs.id
}

output "autoscaling_resource_id" {
  value = aws_appautoscaling_target.ecs.resource_id
}