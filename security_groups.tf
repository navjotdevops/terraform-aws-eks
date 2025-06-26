# Additional Security Group for EKS Cluster
resource "aws_security_group" "cluster_additional" {
  count = var.create_cluster_security_group ? 1 : 0

  name_prefix = "${var.cluster_name}-cluster-additional-"
  vpc_id      = var.vpc_id
  description = "Additional security group for EKS cluster ${var.cluster_name}"

  tags = merge(
    var.tags,
    {
      Name = "${var.cluster_name}-cluster-additional"
    }
  )
}

# Security Group Rules for Cluster
resource "aws_security_group_rule" "cluster_ingress_workstation_https" {
  count = var.create_cluster_security_group && length(var.cluster_security_group_additional_rules) > 0 ? length(var.cluster_security_group_additional_rules) : 0

  description       = var.cluster_security_group_additional_rules[count.index].description
  from_port         = var.cluster_security_group_additional_rules[count.index].from_port
  protocol          = var.cluster_security_group_additional_rules[count.index].protocol
  security_group_id = aws_security_group.cluster_additional[0].id
  to_port           = var.cluster_security_group_additional_rules[count.index].to_port
  type              = var.cluster_security_group_additional_rules[count.index].type
  cidr_blocks       = var.cluster_security_group_additional_rules[count.index].cidr_blocks
  source_security_group_id = var.cluster_security_group_additional_rules[count.index].source_security_group_id
}

# Node Group Security Group
resource "aws_security_group" "node_group_additional" {
  count = var.create_node_security_group && length(var.node_groups) > 0 ? 1 : 0

  name_prefix = "${var.cluster_name}-node-additional-"
  vpc_id      = var.vpc_id
  description = "Additional security group for EKS node groups"

  tags = merge(
    var.tags,
    {
      Name = "${var.cluster_name}-node-additional"
    }
  )
}

# Security Group Rules for Node Groups
resource "aws_security_group_rule" "node_group_additional_rules" {
  count = var.create_node_security_group && length(var.node_security_group_additional_rules) > 0 ? length(var.node_security_group_additional_rules) : 0

  description       = var.node_security_group_additional_rules[count.index].description
  from_port         = var.node_security_group_additional_rules[count.index].from_port
  protocol          = var.node_security_group_additional_rules[count.index].protocol
  security_group_id = aws_security_group.node_group_additional[0].id
  to_port           = var.node_security_group_additional_rules[count.index].to_port
  type              = var.node_security_group_additional_rules[count.index].type
  cidr_blocks       = var.node_security_group_additional_rules[count.index].cidr_blocks
  source_security_group_id = var.node_security_group_additional_rules[count.index].source_security_group_id
}