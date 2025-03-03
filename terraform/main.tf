provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source               = "./modules/vpc"
  cidr_block           = "10.0.0.0/16"
  public_subnet_cidr   = "10.0.1.0/24"
  private_subnet_cidr  = "10.0.2.0/24"
  availability_zone_1  = "us-east-1a"  # AZ 1
  availability_zone_2  = "us-east-1b"  # AZ 2
}


module "eks" {
  source        = "./modules/eks"
  cluster_name  = var.cluster_name
  subnet_ids    = var.subnet_ids
  instance_types = var.instance_types
  vpc_id        = var.vpc_id
}

module "security_groups" {
  source = "./modules/security_groups"
  vpc_id = var.vpc_id
}


module "kubernetes" {
  source = "./modules/kubernetes"
}
