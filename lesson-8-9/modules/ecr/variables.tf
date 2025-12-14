variable "ecr_name" {
  description = "Назва репозиторію ECR"
  type        = string
}

variable "scan_on_push" {
  description = "Чи вмикати сканування образів при push"
  type        = bool
  default     = true
}
