# modules/eks/variables.tf

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the EKS nodes"
  type        = list(string)
}

variable "instance_types" {
  description = "List of EC2 instance types for the worker nodes"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID where the EKS cluster will be deployed"
  type        = string
}
