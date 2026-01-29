output "db_endpoint" {
  description = "Endpoint бази даних (RDS або Aurora writer)"
  value       = module.rds.db_endpoint
}

output "db_reader_endpoint" {
  description = "Reader endpoint для Aurora (якщо використовується)"
  value       = module.rds.db_reader_endpoint
}

output "db_port" {
  description = "Порт бази даних"
  value       = module.rds.db_port
}

output "db_security_group_id" {
  description = "ID security group для бази"
  value       = module.rds.db_security_group_id
}

output "db_subnet_group_name" {
  description = "Назва subnet group для бази"
  value       = module.rds.db_subnet_group_name
}
