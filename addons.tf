# EKS Add-ons
resource "aws_eks_addon" "this" {
  for_each = var.cluster_addons

  cluster_name             = aws_eks_cluster.this.name
  addon_name               = each.key
  addon_version            = each.value.addon_version
  configuration_values     = each.value.configuration_values
  preserve                 = each.value.preserve
  resolve_conflicts        = each.value.resolve_conflicts
  resolve_conflicts_on_create = each.value.resolve_conflicts_on_create
  resolve_conflicts_on_update = each.value.resolve_conflicts_on_update
  service_account_role_arn = each.value.service_account_role_arn

  depends_on = [
    aws_eks_node_group.this,
    aws_eks_fargate_profile.this,
  ]

  tags = merge(
    var.tags,
    each.value.tags,
    {
      Name = "${var.cluster_name}-${each.key}"
    }
  )
}