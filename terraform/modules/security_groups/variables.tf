# modules/security_groups/variables.tf

variable "vpc_id" {
  description = "VPC ID where the security group will be created"
  type        = string
}
