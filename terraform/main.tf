module "vpc" {
  source            = "./modules/vpc"
  cidr_block        = "10.0.0.0/16"
  name              = "my-vpc"
  public_subnets    = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets   = ["10.0.3.0/24", "10.0.4.0/24"]
  availability_zones = ["us-east-1a", "us-east-1b"]
}

module "eks" {
  source          = "./modules/eks"
  cluster_name    = "my-eks-cluster"
  cluster_version = "1.32"  # Updated Kubernetes version
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.public_subnets
}

resource "aws_iam_role" "node_group" {
  name = "eks-node-group-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
    ]
  })
}

resource "aws_eks_node_group" "node_group" {
  cluster_name    = module.eks.cluster_id
  node_group_name = "example"
  node_role_arn   = aws_iam_role.node_group.arn
  subnet_ids      = module.vpc.public_subnets

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  instance_types = ["t3.medium"]

  remote_access {
    ec2_ssh_key = "my-key"
  }
}

resource "kubernetes_deployment" "appointment_service" {
  metadata {
    name = "appointment-service"
    labels = {
      app = "appointment-service"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "appointment-service"
      }
    }

    template {
      metadata {
        labels = {
          app = "appointment-service"
        }
      }

      spec {
        container {
          name  = "appointment-service"
          image = "510278866235.dkr.ecr.us-east-1.amazonaws.com/appointment-service:latest"
          port {
            container_port = 3001
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "appointment_service" {
  metadata {
    name = "appointment-service"
  }

  spec {
    selector = {
      app = "appointment-service"
    }

    port {
      port        = 80
      target_port = 3001
    }

    type = "LoadBalancer"
  }
}
Updated Outputs Configuration
Update the outputs configuration to correctly reference the module outputs.

outputs.tf
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "eks_cluster_id" {
  value = module.eks.cluster_id
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "eks_cluster_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
}

output "eks_cluster_security_group_id" {
  value = module.eks.cluster_security_group_id
}
