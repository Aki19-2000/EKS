# CIDR block for the VPC
variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

# CIDR block for the public subnet
variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
}

# CIDR block for the private subnet
variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
}

# Availability Zone for the first subnet
variable "availability_zone_1" {
  description = "The first availability zone"
  type        = string
}

# Availability Zone for the second subnet
variable "availability_zone_2" {
  description = "The second availability zone"
  type        = string
}

  
