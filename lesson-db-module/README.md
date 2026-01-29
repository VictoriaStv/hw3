# Terraform RDS / Aurora module

Цей модуль піднімає базу даних у AWS в одному з двох режимів:
- звичайна RDS (PostgreSQL / MySQL);
- або Aurora cluster — залежно від прапора `use_aurora`.

## Структура

- `modules/rds` — універсальний модуль:
  - `shared.tf` — спільні ресурси: DB subnet group, security group, parameter groups;
  - `rds.tf` — звичайна `aws_db_instance`;
  - `aurora.tf` — `aws_rds_cluster` + `aws_rds_cluster_instance`;
  - `variables.tf` — усі змінні модуля;
  - `outputs.tf` — основні вихідні дані.

У корені:
- `backend.tf` — бекенд Terraform (S3 + DynamoDB);
- `main.tf` — приклад використання модуля `rds`;
- `outputs.tf` — прокидування вихідних значень модуля.

---

## Приклад використання

Звичайна RDS PostgreSQL:

module "rds" {
  source = "./modules/rds"

  use_aurora        = false
  engine            = "postgres"
  engine_version    = "15.4"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  multi_az          = false

  db_name         = "app_db"
  master_username = "app_user"
  master_password = "change_me_please"

  vpc_id             = "vpc-xxxxxxxx"
  private_subnet_ids = ["subnet-aaaaaaaa", "subnet-bbbbbbbb"]

  allowed_cidr_blocks = ["10.0.0.0/16"]

  tags = {
    project = "lesson-db-module"
  }
}

Для Aurora достатньо змінити:

use_aurora                    = true
aurora_parameter_group_family = "aurora-postgresql15"

(і за потреби — `engine = "postgres"` або `"mysql"` та відповідну `engine_version`).

---

## Основні змінні

- `use_aurora` — перемикає режим: Aurora (`true`) або звичайна RDS (`false`);
- `engine` — `postgres` або `mysql`;
- `engine_version` — версія БД;
- `instance_class` — тип інстансу;
- `allocated_storage` — диск для RDS;
- `multi_az` — Multi-AZ для RDS;
- `db_name`, `master_username`, `master_password`;
- `vpc_id`, `private_subnet_ids`, `allowed_cidr_blocks`;
- `aurora_instances` — кількість інстансів у Aurora;
- `rds_parameter_group_family`, `aurora_parameter_group_family`;
- `tags` — довільні теги.

---

## Базові команди

terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
terraform destroy

Перед реальним `apply` обов'язково:
- підставити коректні `vpc_id` та `private_subnet_ids`;
- змінити `master_password` на свій;
- переконатися, що параметри `*_parameter_group_family` відповідають обраному `engine`.
