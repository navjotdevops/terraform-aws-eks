output "cluster_id" {
  description = "The ID of the EKS cluster"
  value       = aws_eks_cluster.this.id
}

output "cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster"
  value       = aws_eks_cluster.this.arn
}

output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  description = "Endpoint for your Kubernetes API server"
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_version" {
  description = "The Kubernetes server version for the EKS cluster"
  value       = aws_eks_cluster.this.version
}

output "cluster_platform_version" {
  description = "Platform version for the EKS cluster"
  value       = aws_eks_cluster.this.platform_version
}

output "cluster_status" {
  description = "Status of the EKS cluster"
  value       = aws_eks_cluster.this.status
}

output "cluster_security_group_id" {
  description = "Cluster security group that was created by Amazon EKS for the cluster"
  value       = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
}

output "cluster_iam_role_name" {
  description = "IAM role name associated with EKS cluster"
  value       = aws_iam_role.cluster.name
}

output "cluster_iam_role_arn" {
  description = "IAM role ARN associated with EKS cluster"
  value       = aws_iam_role.cluster.arn
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = aws_eks_cluster.this.certificate_authority[0].data
}

output "cluster_oidc_issuer_url" {
  description = "The URL on the EKS cluster for the OpenID Connect identity provider"
  value       = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

output "cluster_primary_security_group_id" {
  description = "The cluster primary security group ID created by the EKS cluster"
  value       = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
}

output "node_groups" {
  description = "Map of attribute maps for all EKS node groups created"
  value = {
    for k, v in aws_eks_node_group.this : k => {
      arn           = v.arn
      status        = v.status
      capacity_type = v.capacity_type
      instance_types = v.instance_types
      ami_type      = v.ami_type
      node_group_name = v.node_group_name
      scaling_config = v.scaling_config
      version       = v.version
    }
  }
}

output "fargate_profiles" {
  description = "Map of attribute maps for all EKS Fargate profiles created"
  value = {
    for k, v in aws_eks_fargate_profile.this : k => {
      arn                    = v.arn
      status                 = v.status
      fargate_profile_name   = v.fargate_profile_name
      pod_execution_role_arn = v.pod_execution_role_arn
    }
  }
}

output "cluster_addons" {
  description = "Map of attribute maps for all EKS cluster addons created"
  value = {
    for k, v in aws_eks_addon.this : k => {
      arn           = v.arn
      status        = v.status
      addon_name    = v.addon_name
      addon_version = v.addon_version
    }
  }
}

output "node_security_group_arn" {
  description = "Amazon Resource Name (ARN) of the node shared security group"
  value       = length(aws_security_group.node_group_additional) > 0 ? aws_security_group.node_group_additional[0].arn : null
}

output "node_security_group_id" {
  description = "ID of the node shared security group"
  value       = length(aws_security_group.node_group_additional) > 0 ? aws_security_group.node_group_additional[0].id : null
}

output "cluster_token" {
  description = "Token for authentication to the EKS cluster"
  value       = data.aws_eks_cluster_auth.this.token
  sensitive   = true
}