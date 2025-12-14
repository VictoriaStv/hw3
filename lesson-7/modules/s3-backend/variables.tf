variable "bucket_name" {
  description = "Ім'я S3-бакета для Terraform state"
  type        = string
}

variable "table_name" {
  description = "Ім'я DynamoDB-таблиці для блокувань state"
  type        = string
}
