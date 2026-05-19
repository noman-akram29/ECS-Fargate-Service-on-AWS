variable "aws_region" {
  type        = string
  description = "AWS region for backend infrastructure"
  default     = "us-east-1"
}

variable "environment" {
  type        = string
  description = "Deployment environment"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}