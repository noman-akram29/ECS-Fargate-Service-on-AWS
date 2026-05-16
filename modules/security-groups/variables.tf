variable "environment" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "vpc_id" {
  description = "VPC ID where resources will be created"
  type        = string
}