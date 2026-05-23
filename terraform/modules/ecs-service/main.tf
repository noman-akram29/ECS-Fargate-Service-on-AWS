resource "aws_ecs_task_definition" "this" {
  family                   = "${var.environment}-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"

  cpu    = var.task_cpu
  memory = var.task_memory

  execution_role_arn = var.execution_role_arn
  task_role_arn      = var.task_role_arn

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  ephemeral_storage {
    size_in_gib = 30
  }

  container_definitions = jsonencode([
    {
      name  = "app"
      image = var.ecr_image_uri

      essential = true
      readonlyRootFilesystem = true

      portMappings = [
        {
          containerPort = var.container_port
          protocol      = "tcp"
        }
      ]

       healthCheck = {
        command     = ["CMD-SHELL", "curl -k -f https://localhost:${var.container_port}/health || exit 1"]
        interval    = 30
        timeout     = 5
        retries     = 3
        startPeriod = 30
      }
      #  healthCheck = {
      #   command     = ["CMD-SHELL", "curl -f http://localhost:${var.container_port}/health || exit 1"]
      #   interval    = 30
      #   timeout     = 5
      #   retries     = 3
      #   startPeriod = 30
      # }

      environment = [
        {
          name  = "NODE_ENV"
          value = var.environment
        }
      ]

      secrets = [
        {
          name      = "DATABASE_URL"
          valueFrom = var.db_secret_arn
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = var.log_group_name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  tags = var.tags
}

resource "aws_ecs_service" "this" {
  name            = "${var.environment}-service"
  cluster         = var.cluster_name
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = var.desired_count
  enable_execute_command = true
  
  platform_version = "1.4.0"

  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  health_check_grace_period_seconds = 60
  
  launch_type     = "FARGATE"

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [var.ecs_security_group_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = "app"
    container_port   = var.container_port
  }

  deployment_controller {
    type = "ECS"
  }

  # force_new_deployment = true

  lifecycle {
    ignore_changes = [desired_count]
  }

  tags = var.tags

  # depends_on = [
  #   aws_ecs_task_definition.this
  # ]

}
