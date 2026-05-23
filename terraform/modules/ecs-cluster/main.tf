resource "aws_ecs_cluster" "this" {
  name = "${var.environment}-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  configuration {
    execute_command_configuration {
      logging = "OVERRIDE"

      log_configuration {
        cloud_watch_log_group_name = "/ecs/${var.environment}-exec"

        cloud_watch_encryption_enabled = true
      }
    }
  }

  tags = merge(var.tags, {
    Name = "${var.environment}-ecs-cluster"
  })

  # lifecycle {
  #   prevent_destroy = true
  # }
}