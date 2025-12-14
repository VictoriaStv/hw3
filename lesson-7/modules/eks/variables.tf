variable "cluster_name" {
  description = "Назва EKS-кластера"
  type        = string
}

variable "cluster_version" {
  description = "Версія Kubernetes для EKS"
  type        = string
}

variable "vpc_id" {
  description = "ID VPC для EKS"
  type        = string
}

variable "private_subnet_ids" {
  description = "Приватні підмережі для нод"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "Публічні підмережі (для балансувальників)"
  type        = list(string)
}

variable "node_group_min_size" {
  description = "Мінімальна кількість нод у групі"
  type        = number
}

variable "node_group_max_size" {
  description = "Максимальна кількість нод у групі"
  type        = number
}

variable "node_group_desired_size" {
  description = "Бажана кількість нод у групі"
  type        = number
}
