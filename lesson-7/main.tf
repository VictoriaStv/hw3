provider "aws" {
  region = "us-west-2"
}

# S3 + DynamoDB для бекенду
module "s3_backend" {
  source      = "./modules/s3-backend"
  bucket_name = "lesson-5-terraform-state-vika"
  table_name  = "terraform-locks"
}

# VPC з публічними та приватними підмережами
module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr_block     = "10.0.0.0/16"
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets    = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]
  vpc_name           = "lesson-7-vpc"
}

# ECR для Docker-образів
module "ecr" {
  source       = "./modules/ecr"
  ecr_name     = "lesson-7-ecr"
  scan_on_push = true
}

# EKS-кластер у нашій VPC
module "eks" {
  source                  = "./modules/eks"
  cluster_name            = "lesson-7-eks"
  cluster_version         = "1.30"
  vpc_id                  = module.vpc.vpc_id
  private_subnet_ids      = module.vpc.private_subnet_ids
  public_subnet_ids       = module.vpc.public_subnet_ids
  node_group_min_size     = 2
  node_group_max_size     = 6
  node_group_desired_size = 2
}
