output "db_endpoint" {
  description = "Endpoint бази даних (RDS або Aurora writer)"
  value       = var.use_aurora ? aws_rds_cluster.this[0].endpoint : aws_db_instance.this[0].address
}

output "db_reader_endpoint" {
  description = "Reader endpoint для Aurora (якщо використовується)"
  value       = var.use_aurora ? aws_rds_cluster.this[0].reader_endpoint : null
}

output "db_port" {
  description = "Порт бази даних"
  value       = local.db_port
}

output "db_security_group_id" {
  description = "ID security group для бази"
  value       = aws_security_group.db_sg.id
}

output "db_subnet_group_name" {
  description = "Назва subnet group для бази"
  value       = aws_db_subnet_group.this.name
}
