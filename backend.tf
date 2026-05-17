terraform {
  backend "s3" {
    bucket         = "ili-terraform-state-prod-001"
    key            = "ili-assessment/prod/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}