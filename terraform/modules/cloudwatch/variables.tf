variable "environment" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "retention_in_days" {
  type    = number
  default = 30

  validation {
    condition = contains([
      1,3,5,7,14,30,60,90,120,150,180,365
    ], var.retention_in_days)

    error_message = "Invalid CloudWatch retention period."
  }
}