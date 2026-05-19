variable "environment" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "service_name" {
  type = string
}

variable "min_capacity" {
  type = number
}

variable "max_capacity" {
  type = number
}

variable "cpu_target_value" {
  type    = number
  default = 70
}

variable "memory_target_value" {
  type    = number
  default = 75
}

variable "tags" {
  type = map(string)
}