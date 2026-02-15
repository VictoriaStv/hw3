terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

# ------------------------
# S3 backend (bucket + DynamoDB для стейту)
# ------------------------
module "s3_backend" {
  source      = "./modules/s3-backend"
  bucket_name = "lesson-5-terraform-state-vika"
  table_name  = "terraform-locks"
}

# ------------------------
# VPC
# ------------------------
module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr_block     = "10.0.0.0/16"
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets    = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]
  vpc_name           = "final-vpc"
}

# ------------------------
# ECR
# ------------------------
module "ecr" {
  source       = "./modules/ecr"
  ecr_name     = "final-django-ecr"
  scan_on_push = true
}

# ------------------------
# EKS
# ------------------------
module "eks" {
  source = "./modules/eks"

  cluster_name    = "final-eks"
  cluster_version = "1.29"

  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids

  node_group_min_size     = 2
  node_group_max_size     = 4
  node_group_desired_size = 2
}

# ------------------------
# RDS / Aurora
# ------------------------
module "rds" {
  source     = "./modules/rds"
  use_aurora = true

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  allowed_cidr_blocks = [
    "10.0.0.0/16"
  ]

  db_name         = "finaldb"
  master_username = "dbadmin"
  master_password = "ChangeMe123!"

  engine         = "aurora-postgresql"
  engine_version = "15.4"

  instance_class    = "db.r6g.large"
  allocated_storage = 50
  multi_az          = false
  aurora_instances  = 2

  rds_parameter_group_family    = "aurora-postgresql15"
  aurora_parameter_group_family = "aurora-postgresql15"

  tags = {
    Project = "final-devops"
    Owner   = "Victoria"
  }
}

# ------------------------
# Jenkins (через Helm)
# ------------------------
module "jenkins" {
  source = "./modules/jenkins"

  release_name  = "jenkins"
  namespace     = "jenkins"
  chart_version = "5.5.8"
  values_file   = "${path.module}/modules/jenkins/values.yaml"
}

# ------------------------
# Argo CD (GitOps)
# ------------------------
module "argo_cd" {
  source = "./modules/argo_cd"

  release_name  = "argo-cd"
  namespace     = "argocd"
  chart_version = "6.7.4"
  values_file   = "${path.module}/modules/argo_cd/values.yaml"

  # те, чого не вистачало: шлях до charts з ArgoCD applications
  apps_chart_path = "${path.module}/modules/argo_cd/charts"
}

# ------------------------
# Monitoring (Prometheus + Grafana)
# ------------------------
module "monitoring" {
  source = "./modules/monitoring"

  release_name  = "kube-prometheus-stack"
  namespace     = "monitoring"
  chart_version = "65.5.0"
}
