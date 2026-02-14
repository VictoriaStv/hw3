variable "use_aurora" {
  description = "Якщо true — створюємо Aurora cluster, якщо false — звичайну RDS"
  type        = bool
  default     = false
}

variable "engine" {
  description = "Тип двигуна бази даних (postgres або mysql)"
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "Версія двигуна бази даних"
  type        = string
  default     = "15.4"
}

variable "instance_class" {
  description = "Тип інстансу RDS/Aurora"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Розмір диска для звичайної RDS (у GiB)"
  type        = number
  default     = 20
}

variable "multi_az" {
  description = "Увімкнути Multi-AZ для звичайної RDS"
  type        = bool
  default     = false
}

variable "db_name" {
  description = "Назва бази даних"
  type        = string
}

variable "master_username" {
  description = "Користувач БД"
  type        = string
}

variable "master_password" {
  description = "Пароль користувача БД"
  type        = string
  sensitive   = true
}

variable "vpc_id" {
  description = "ID VPC, де буде розміщена база"
  type        = string
}

variable "private_subnet_ids" {
  description = "Приватні сабнети для DB subnet group"
  type        = list(string)
}

variable "allowed_cidr_blocks" {
  description = "CIDR-блоки, яким дозволено доступ до БД"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "aurora_instances" {
  description = "Кількість інстансів у Aurora cluster"
  type        = number
  default     = 1
}

variable "rds_parameter_group_family" {
  description = "Family для звичайної RDS (наприклад postgres15, mysql8.0)"
  type        = string
  default     = "postgres15"
}

variable "aurora_parameter_group_family" {
  description = "Family для Aurora (наприклад aurora-postgresql15, aurora-mysql8.0)"
  type        = string
  default     = "aurora-postgresql15"
}

variable "tags" {
  description = "Додаткові теги для всіх ресурсів"
  type        = map(string)
  default     = {}
}
