variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "db_secret_arn" {
  type = string
}

variable "desired_count" {
  type    = number
  default = 2
}

variable "ecr_image_uri" {
  type = string
}

variable "enable_https" {
  type    = bool
  default = false
}

variable "acm_certificate_arn" {
  type    = string
  default = null
}