output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "VPC ID"
}

output "public_subnets" {
  value       = module.vpc.public_subnet_ids
  description = "Public subnet IDs"
}

output "private_subnets" {
  value       = module.vpc.private_subnet_ids
  description = "Private subnet IDs"
}

output "eks_cluster_name" {
  value       = module.eks.cluster_name
  description = "EKS cluster name"
}

output "rds_endpoint" {
  value       = module.rds.db_endpoint
  description = "RDS/Aurora endpoint"
}

output "ecr_repository_url" {
  value       = module.ecr.repository_url
  description = "ECR repository URL"
}
