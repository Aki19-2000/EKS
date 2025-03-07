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
  cluster_version = "1.21"
  subnets         = module.vpc.public_subnets
  vpc_id          = module.vpc.vpc_id

  node_groups = {
    node_group_1 = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1

      instance_type = "t3.medium"

      key_name = "my-key"
    }
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
