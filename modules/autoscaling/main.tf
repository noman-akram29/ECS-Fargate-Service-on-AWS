resource "aws_appautoscaling_target" "ecs" {
  service_namespace  = "ecs"
  scalable_dimension = "ecs:service:DesiredCount"

  resource_id = "service/${var.cluster_name}/${var.service_name}"

  min_capacity = var.min_capacity
  max_capacity = var.max_capacity
}

resource "aws_appautoscaling_policy" "cpu_tracking" {
  name               = "${var.environment}-cpu-tracking"
  policy_type        = "TargetTrackingScaling"

  service_namespace  = aws_appautoscaling_target.ecs.service_namespace
  scalable_dimension = aws_appautoscaling_target.ecs.scalable_dimension
  resource_id        = aws_appautoscaling_target.ecs.resource_id

  target_tracking_scaling_policy_configuration {

    target_value = 50  # single balanced target

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    scale_out_cooldown = 120
    scale_in_cooldown  = 180
  }
}