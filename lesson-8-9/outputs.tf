output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets_ids
}

output "private_subnets" {
  value = module.vpc.private_subnets_ids
}

output "ecr_repo_url" {
  value = module.ecr.repository_url
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "jenkins_namespace" {
  value = module.jenkins.namespace
}

output "argo_cd_namespace" {
  value = module.argo_cd.namespace
}
