output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "ID створеної VPC"
}

output "public_subnet_ids" {
  value       = module.vpc.public_subnet_ids
  description = "ID публічних підмереж"
}

output "private_subnet_ids" {
  value       = module.vpc.private_subnet_ids
  description = "ID приватних підмереж"
}

output "ecr_repository_url" {
  value       = module.ecr.repository_url
  description = "URL репозиторію ECR"
}

output "eks_cluster_name" {
  value       = module.eks.cluster_name
  description = "Назва EKS-кластера"
}

output "eks_cluster_endpoint" {
  value       = module.eks.cluster_endpoint
  description = "Endpoint EKS-кластера"
}
