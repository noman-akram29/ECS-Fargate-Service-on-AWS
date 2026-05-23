variable "environment" {
  type = string
}

variable "db_secret_arn" {
  type = string
}

variable "tags" {
  type = map(string)
}