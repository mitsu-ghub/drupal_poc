terraform {
    required_version = "~> 1.3.2"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.28.0"
    }
    null = {
      source = "hashicorp/null"
      version = "3.1.1"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.6.0"
    }
    http = {
      source = "hashicorp/http"
      version = "3.1.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.13.1"
    }
    random = {
      source = "hashicorp/random"
      version = "3.4.3"
    }
  }

  backend "s3" {

    bucket = "techm-terraform-tfstate-bucket"
    key = "techm/dev/terraform.tfstate"
    profile = "BORN"
    region = "ca-central-1"

    dynamodb_table = "techm-dev-eks-cluster"
  }
}


provider "aws" {
  region = var.region
  profile = var.profile
}

provider "null" {
  # Configuration options
}

provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.eks_cluster.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.eks_cluster.certificate_authority[0].data)
    exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", "TechM-dev-eks-cluster", "--profile", "BORN" ]
    command     = "aws"
    }
  }
}

provider "http" {
  # Configuration options
}

provider "kubernetes" {
    host                   = aws_eks_cluster.eks_cluster.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.eks_cluster.certificate_authority[0].data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", "TechM-dev-eks-cluster", "--profile", "BORN" ]
    command     = "aws"
  }
}

provider "random" {
  # Configuration options
}