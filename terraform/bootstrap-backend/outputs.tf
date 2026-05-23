output "terraform_state_bucket" {
  description = "Terraform state bucket name"
  value       = aws_s3_bucket.tf_state.bucket
}

output "terraform_lock_table" {
  description = "Terraform DynamoDB lock table name"
  value       = aws_dynamodb_table.lock.name
}

output "kms_key_arn" {
  description = "KMS key ARN"
  value       = aws_kms_key.terraform.arn
}