variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version to use for the EKS cluster"
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "ID of the VPC where the cluster will be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "cluster_endpoint_private_access" {
  description = "Enable private API server endpoint"
  type        = bool
  default     = true
}

variable "cluster_endpoint_public_access" {
  description = "Enable public API server endpoint"
  type        = bool
  default     = false
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "List of CIDR blocks that can access the public API server endpoint"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "cluster_additional_security_group_ids" {
  description = "List of additional security group IDs to attach to the cluster"
  type        = list(string)
  default     = []
}

variable "cluster_access_config" {
  description = "Configuration block for the cluster access config"
  type = object({
    authentication_mode                         = optional(string, "API_AND_CONFIG_MAP")
    bootstrap_cluster_creator_admin_permissions = optional(bool, true)
  })
  default = null
}

variable "cluster_compute_config" {
  description = "Configuration block for EKS Auto Mode"
  type = object({
    enabled       = bool
    node_pools    = optional(list(string))
    node_role_arn = optional(string)
  })
  default = null
}

variable "cluster_encryption_config" {
  description = "Configuration block with encryption configuration for the cluster"
  type = list(object({
    provider_key_arn = string
    resources        = list(string)
  }))
  default = []
}

variable "cluster_ip_family" {
  description = "The IP family used to assign Kubernetes pod and service addresses"
  type        = string
  default     = null
}

variable "cluster_service_ipv4_cidr" {
  description = "The CIDR block to assign Kubernetes service IP addresses from"
  type        = string
  default     = null
}

variable "cluster_service_ipv6_cidr" {
  description = "The CIDR block to assign Kubernetes service IPv6 addresses from"
  type        = string
  default     = null
}

variable "cluster_enabled_log_types" {
  description = "List of control plane logging to enable"
  type        = list(string)
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "cloudwatch_log_group_retention_in_days" {
  description = "Number of days to retain log events"
  type        = number
  default     = 90
}

variable "cloudwatch_log_group_kms_key_id" {
  description = "The ARN of the KMS Key to use when encrypting log data"
  type        = string
  default     = null
}

variable "node_groups" {
  description = "Map of EKS node group definitions"
  type = map(object({
    subnet_ids         = list(string)
    capacity_type      = optional(string, "ON_DEMAND")
    instance_types     = optional(list(string), ["t3.medium"])
    ami_type          = optional(string, "AL2_x86_64")
    disk_size         = optional(number, 20)
    kubernetes_version = optional(string)
    desired_size      = optional(number, 1)
    max_size          = optional(number, 3)
    min_size          = optional(number, 1)
    labels            = optional(map(string), {})
    taints = optional(list(object({
      key    = string
      value  = optional(string)
      effect = string
    })), [])
    update_config = optional(object({
      max_unavailable_percentage = optional(number)
      max_unavailable           = optional(number)
    }))
    remote_access = optional(object({
      ec2_ssh_key               = optional(string)
      source_security_group_ids = optional(list(string))
    }))
    launch_template = optional(object({
      id      = optional(string)
      name    = optional(string)
      version = optional(string)
    }))
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "fargate_profiles" {
  description = "Map of EKS Fargate profile definitions"
  type = map(object({
    subnet_ids = list(string)
    selectors = list(object({
      namespace = string
      labels    = optional(map(string), {})
    }))
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "cluster_addons" {
  description = "Map of cluster addon configurations"
  type = map(object({
    addon_version                = optional(string)
    configuration_values         = optional(string)
    preserve                     = optional(bool, true)
    resolve_conflicts           = optional(string, "OVERWRITE")
    resolve_conflicts_on_create = optional(string, "OVERWRITE")
    resolve_conflicts_on_update = optional(string, "OVERWRITE")
    service_account_role_arn    = optional(string)
    tags                        = optional(map(string), {})
  }))
  default = {}
}

variable "enable_default_addons" {
  description = "Enable default EKS addons (coredns, kube-proxy, vpc-cni)"
  type        = bool
  default     = true
}

variable "create_cluster_security_group" {
  description = "Create additional security group for the cluster"
  type        = bool
  default     = false
}

variable "cluster_security_group_additional_rules" {
  description = "List of additional security group rules for the cluster"
  type = list(object({
    description              = string
    from_port               = number
    to_port                 = number
    protocol                = string
    type                    = string
    cidr_blocks             = optional(list(string))
    source_security_group_id = optional(string)
  }))
  default = []
}

variable "create_node_security_group" {
  description = "Create additional security group for node groups"
  type        = bool
  default     = false
}

variable "node_security_group_additional_rules" {
  description = "List of additional security group rules for node groups"
  type = list(object({
    description              = string
    from_port               = number
    to_port                 = number
    protocol                = string
    type                    = string
    cidr_blocks             = optional(list(string))
    source_security_group_id = optional(string)
  }))
  default = []
}

variable "node_security_group_additional_ids" {
  description = "List of additional security group IDs to attach to node groups"
  type        = list(string)
  default     = []
}

variable "cluster_tags" {
  description = "A map of tags to assign to the cluster"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "A map of tags to assign to all resources"
  type        = map(string)
  default     = {}
}