provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source               = "./modules/vpc"
  cidr_block           = "10.0.0.0/16"
  public_subnet_cidr   = "10.0.1.0/24"
  private_subnet_cidr  = "10.0.2.0/24"
  availability_zone_1  = "us-east-1a"
  availability_zone_2  = "us-east-1b"
}

module "eks" {
  source        = "./modules/eks"
  cluster_name  = var.cluster_name
  subnet_ids    = [module.vpc.subnet_public_id, module.vpc.subnet_private_id]  # Use the outputs from the VPC module
  instance_types = var.instance_types
  vpc_id        = module.vpc.vpc_id  # Get VPC ID from module output
}

module "security_groups" {
  source = "./modules/security_groups"
  vpc_id = module.vpc.vpc_id  # Use the VPC ID from the VPC module
}

module "kubernetes" {
  source = "./modules/kubernetes"
}
