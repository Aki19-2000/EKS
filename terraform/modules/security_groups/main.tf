resource "aws_security_group" "eks_sg" {
  name        = "eks-security-group"
  description = "Security group for EKS cluster nodes"
  vpc_id      = var.vpc_id  # Use the vpc_id variable here

  # Ingress rules for worker node communication
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow inbound traffic from EKS control plane (HTTPS)
    description = "Allow HTTPS from EKS control plane"
  }

  ingress {
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow kubelet traffic between nodes
    description = "Allow Kubelet traffic"
  }

  # Egress rules for worker node outbound communication
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EKS Worker Node SG"
  }
}
