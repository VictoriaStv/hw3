provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

module "rds" {
  source = "./modules/rds"

  # Логіка: якщо true — Aurora, якщо false — звичайна RDS
  use_aurora        = false
  engine            = "postgres"
  engine_version    = "15.4"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  multi_az          = false

  db_name         = "app_db"
  master_username = "app_user"
  master_password = "change_me_please" # перед реальним apply краще змінити

  # Тут потрібно буде підставити свої значення перед запуском у AWS
  vpc_id             = "vpc-xxxxxxxx"
  private_subnet_ids = ["subnet-aaaaaaaa", "subnet-bbbbbbbb"]

  allowed_cidr_blocks = ["10.0.0.0/16"]

  tags = {
    project = "lesson-db-module"
    owner   = "Victoria"
  }
}
