#######################################
# OUTPUTS — Вивід ключової інформації
#######################################

output "s3_bucket_name" {
  description = "Ім'я S3 бакету для Terraform state"
  value       = module.s3_backend.bucket_name
}

output "dynamodb_table_name" {
  description = "Ім'я DynamoDB таблиці для локів"
  value       = module.s3_backend.dynamodb_table_name
}

output "vpc_id" {
  description = "ID створеної VPC"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "Публічні підмережі"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "Приватні підмережі"
  value       = module.vpc.private_subnets
}

output "ecr_repository_url" {
  description = "URL ECR репозиторію"
  value       = module.ecr.repository_url
}
