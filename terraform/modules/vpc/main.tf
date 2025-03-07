# Create a custom VPC
resource "aws_vpc" "custom_vpc" {
  cidr_block = var.cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "Custom VPC"
  }
}

# Create Public Subnet
resource "aws_subnet" "subnet_public" {
  vpc_id            = aws_vpc.custom_vpc.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = var.availability_zone_1
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet"
  }
}

# Create Private Subnet
resource "aws_subnet" "subnet_private" {
  vpc_id            = aws_vpc.custom_vpc.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.availability_zone_2

  tags = {
    Name = "Private Subnet"
  }
}

# Create Internet Gateway and attach it to the VPC
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.custom_vpc.id

  tags = {
    Name = "Internet Gateway"
  }
}

# Create Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  vpc = true
}

# Create NAT Gateway in the public subnet
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.subnet_public.id

  depends_on = [aws_internet_gateway.main]

  tags = {
    Name = "NAT Gateway"
  }
}

# Create Route Table for Public Subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.custom_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

# Associate Public Subnet with Route Table
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.subnet_public.id
  route_table_id = aws_route_table.public.id
}

# Create Route Table for Private Subnet
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.custom_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id  # Route internet traffic through NAT Gateway
  }

  tags = {
    Name = "Private Route Table"
  }
}

# Associate Private Subnet with Route Table
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.subnet_private.id
  route_table_id = aws_route_table.private.id
}

# Output the Public Subnet ID
output "subnet_public_id" {
  value = aws_subnet.subnet_public.id
}

# Output the Private Subnet ID
output "subnet_private_id" {
  value = aws_subnet.subnet_private.id
}

# Output the VPC ID
output "vpc_id" {
  value = aws_vpc.custom_vpc.id
}


