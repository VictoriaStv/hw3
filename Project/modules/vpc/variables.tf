variable "vpc_cidr_block" {
  description = "CIDR-блок для VPC"
  type        = string
}

variable "public_subnets" {
  description = "Список CIDR для публічних підмереж"
  type        = list(string)
}

variable "private_subnets" {
  description = "Список CIDR для приватних підмереж"
  type        = list(string)
}

variable "availability_zones" {
  description = "Список availability zones"
  type        = list(string)
}

variable "vpc_name" {
  description = "Назва VPC (тег Name)"
  type        = string
}
