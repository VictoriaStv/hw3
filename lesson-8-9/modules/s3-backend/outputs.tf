output "bucket_id" {
  value       = aws_s3_bucket.terraform_state.id
  description = "ID S3-бакета для Terraform state"
}

output "dynamodb_table_name" {
  value       = aws_dynamodb_table.terraform_locks.name
  description = "Назва DynamoDB-таблиці для блокувань"
}
