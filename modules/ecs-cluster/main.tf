resource "aws_ecs_cluster" "this" {
  name = "${var.environment}-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = merge(var.tags, {
    Name = "${var.environment}-ecs-cluster"
  })
}