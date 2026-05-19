# Data Source: Current AWS Account
data "aws_caller_identity" "current" {}

# ECS Execution Role
resource "aws_iam_role" "execution_role" {
  name = "${var.environment}-ecs-execution-role"
  path = "/ecs/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      },
      Action = "sts:AssumeRole",
      Condition = {
        StringEquals = {
          "aws:SourceAccount" = data.aws_caller_identity.current.account_id
        }
      }
    }]
  })

  tags = var.tags
}

# Attach AWS-managed ECS execution policy
resource "aws_iam_role_policy_attachment" "execution_role_policy_attach" {
  role       = aws_iam_role.execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ✅ FIX: Allow ECS execution role to fetch secrets during task startup
resource "aws_iam_role_policy" "execution_secrets_policy" {
  name = "${var.environment}-ecs-execution-role-secrets-policy"
  role = aws_iam_role.execution_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "secretsmanager:GetSecretValue"
        ],
        Resource = "${var.db_secret_arn}*"
      }
    ]
  })
}

# ECS Task Role
resource "aws_iam_role" "task_role" {
  name = "${var.environment}-ecs-task-role"
  path = "/ecs/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      },
      Action = "sts:AssumeRole",
      Condition = {
        StringEquals = {
          "aws:SourceAccount" = data.aws_caller_identity.current.account_id
        }
      }
    }]
  })

  tags = var.tags
}

# Task role policy: secrets access only (kept as-is)
resource "aws_iam_role_policy" "task_secrets_policy" {
  name = "${var.environment}-ecs-task-role-secrets-policy"
  role = aws_iam_role.task_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["secretsmanager:GetSecretValue"],
        Resource = var.db_secret_arn
      }
    ]
  })
}