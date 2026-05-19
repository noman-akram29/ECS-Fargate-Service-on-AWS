resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/${var.environment}-app"
  retention_in_days = var.retention_in_days

  tags = merge(var.tags, {
    Name = "${var.environment}-ecs-logs"
  })

  # lifecycle {
  #   prevent_destroy = true
  # }
}