variable "environment" {
  type = string
}

variable "public_subnet_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "tags" {
  type = map(string)
}

variable "vpc_id" {
  description = "VPC ID where resources will be created"
  type        = string
}