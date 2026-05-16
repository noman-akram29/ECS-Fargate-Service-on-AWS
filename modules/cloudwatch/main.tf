resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/${var.environment}-app"
  retention_in_days = 30

  tags = merge(var.tags, {
    Name = "${var.environment}-ecs-logs"
  })
}