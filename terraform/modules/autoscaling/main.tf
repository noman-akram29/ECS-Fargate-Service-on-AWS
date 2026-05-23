resource "aws_appautoscaling_target" "ecs" {
  service_namespace  = "ecs"
  scalable_dimension = "ecs:service:DesiredCount"

  resource_id = "service/${var.cluster_name}/${var.service_name}"

  min_capacity = var.min_capacity
  max_capacity = var.max_capacity

  tags = var.tags
}

resource "aws_appautoscaling_policy" "cpu_tracking" {
  name               = "${var.environment}-cpu-tracking"
  policy_type        = "TargetTrackingScaling"

  service_namespace  = aws_appautoscaling_target.ecs.service_namespace
  scalable_dimension = aws_appautoscaling_target.ecs.scalable_dimension
  resource_id        = aws_appautoscaling_target.ecs.resource_id

  target_tracking_scaling_policy_configuration {

    target_value = var.cpu_target_value

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    scale_out_cooldown = 120
    scale_in_cooldown  = 180
    
    disable_scale_in = false
  }
}

resource "aws_appautoscaling_policy" "memory_tracking" {
  name               = "${var.environment}-memory-tracking"
  policy_type        = "TargetTrackingScaling"

  service_namespace  = aws_appautoscaling_target.ecs.service_namespace
  scalable_dimension = aws_appautoscaling_target.ecs.scalable_dimension
  resource_id        = aws_appautoscaling_target.ecs.resource_id

  target_tracking_scaling_policy_configuration {
    target_value = var.memory_target_value

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    scale_out_cooldown = 120
    scale_in_cooldown  = 180

    disable_scale_in = false
  }
}