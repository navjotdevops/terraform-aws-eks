# Data sources
data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

# EKS Cluster Auth
data "aws_eks_cluster_auth" "this" {
  name = aws_eks_cluster.this.name
}

# Latest EKS optimized AMI
data "aws_ami" "eks_default" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amazon-eks-node-${var.cluster_version}-v*"]
  }
}