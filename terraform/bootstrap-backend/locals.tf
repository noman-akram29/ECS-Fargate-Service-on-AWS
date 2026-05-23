locals {
  tags = {
    Environment = var.environment
    ManagedBy   = "terraform"
    Project     = "ili-app"
  }
}