terraform {
  required_version = ">= 1.4.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

# Kubernetes/Helm провайдери прив’язані до EKS (дані беремо з модуля eks)
provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate)
  token                  = module.eks.cluster_token
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate)
    token                  = module.eks.cluster_token
  }
}

# S3 + DynamoDB для бекенду (можна не застосовувати вдруге, але модуль лишаємо для повноти)
module "s3_backend" {
  source     = "./modules/s3-backend"
  bucket_name = "lesson-5-terraform-state-vika"
  table_name  = "terraform-locks"
}

# VPC
module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr_block     = "10.0.0.0/16"
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets    = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]
  vpc_name           = "lesson-8-9-vpc"
}

# ECR для Django-образу
module "ecr" {
  source       = "./modules/ecr"
  ecr_name     = "lesson-8-9-django-ecr"
  scan_on_push = true
}

# EKS кластер
module "eks" {
  source              = "./modules/eks"
  cluster_name        = "lesson-8-9-eks"
  cluster_version     = "1.29"
  vpc_id              = module.vpc.vpc_id
  private_subnets_ids = module.vpc.private_subnets_ids
  public_subnets_ids  = module.vpc.public_subnets_ids

  desired_size = 2
  min_size     = 2
  max_size     = 4
  instance_types = ["t3.medium"]
}

# Jenkins, встановлений через Helm
module "jenkins" {
  source = "./modules/jenkins"

  namespace       = "jenkins"
  release_name    = "jenkins"
  chart_version   = "5.5.14"
  values_file     = "${path.module}/modules/jenkins/values.yaml"
}

# Argo CD, встановлений через Helm
module "argo_cd" {
  source = "./modules/argo_cd"

  namespace       = "argocd"
  release_name    = "argo-cd"
  chart_version   = "7.7.10"
  values_file     = "${path.module}/modules/argo_cd/values.yaml"

  apps_chart_path = "${path.module}/modules/argo_cd/charts"
}
