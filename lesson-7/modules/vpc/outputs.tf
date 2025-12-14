output "vpc_id" {
  value       = aws_vpc.main.id
  description = "ID створеної VPC"
}

output "public_subnet_ids" {
  value       = [for s in aws_subnet.public : s.id]
  description = "ID публічних підмереж"
}

output "private_subnet_ids" {
  value       = [for s in aws_subnet.private : s.id]
  description = "ID приватних підмереж"
}
