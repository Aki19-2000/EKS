# Create an IAM role for EKS cluster
resource "aws_iam_role" "eks_role" {
  name               = "eks-cluster-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Effect    = "Allow"
        Sid       = ""
      }
    ]
  })
}

# Attach the Amazon EKS Cluster Policy to the IAM role
resource "aws_iam_role_policy_attachment" "eks_policy" {
  role       = aws_iam_role.eks_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# Create an IAM role for EKS node group
resource "aws_iam_role" "eks_node_role" {
  name               = "eks-node-group-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Effect    = "Allow"
        Sid       = ""
      }
    ]
  })
}

# Attach the Amazon EKS Worker Node Policy to the IAM role
resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

# Attach the Amazon EC2 Container Registry Read-Only Policy to the IAM role
resource "aws_iam_role_policy_attachment" "eks_worker_ecr_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_role.arn  # Reference the IAM role for EKS cluster

  vpc_config {
    subnet_ids = var.subnet_ids
    endpoint_public_access = true
  }

  depends_on = [aws_iam_role_policy_attachment.eks_policy]
}


resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "worker-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn  # Use the IAM role for the node group
  subnet_ids      = var.subnet_ids
  instance_types  = var.instance_types
  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  depends_on = [aws_eks_cluster.main]
}
