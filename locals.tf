# Local values
locals {
  # Common tags
  common_tags = merge(
    var.tags,
    {
      "kubernetes.io/cluster/${var.cluster_name}" = "owned"
      "ManagedBy"                                 = "Terraform"
    }
  )

  # Cluster security group IDs
  cluster_security_group_ids = compact(concat(
    var.cluster_additional_security_group_ids,
    var.create_cluster_security_group ? [aws_security_group.cluster_additional[0].id] : []
  ))

  # Node group security group IDs
  node_security_group_ids = compact(concat(
    var.node_security_group_additional_ids,
    var.create_node_security_group && length(var.node_groups) > 0 ? [aws_security_group.node_group_additional[0].id] : []
  ))

  # Default add-ons
  default_addons = {
    coredns = {
      addon_version                = null
      configuration_values         = null
      preserve                     = true
      resolve_conflicts           = "OVERWRITE"
      resolve_conflicts_on_create = "OVERWRITE"
      resolve_conflicts_on_update = "OVERWRITE"
      service_account_role_arn    = null
      tags                        = {}
    }
    kube-proxy = {
      addon_version                = null
      configuration_values         = null
      preserve                     = true
      resolve_conflicts           = "OVERWRITE"
      resolve_conflicts_on_create = "OVERWRITE"
      resolve_conflicts_on_update = "OVERWRITE"
      service_account_role_arn    = null
      tags                        = {}
    }
    vpc-cni = {
      addon_version                = null
      configuration_values         = null
      preserve                     = true
      resolve_conflicts           = "OVERWRITE"
      resolve_conflicts_on_create = "OVERWRITE"
      resolve_conflicts_on_update = "OVERWRITE"
      service_account_role_arn    = null
      tags                        = {}
    }
  }

  # Merge default and custom add-ons
  cluster_addons = merge(
    var.enable_default_addons ? local.default_addons : {},
    var.cluster_addons
  )
}