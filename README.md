# Terraform AWS EKS Module

A comprehensive and flexible Terraform module for deploying AWS EKS clusters with support for auto mode, Fargate profiles, node groups, and essential add-ons.

## 🏗️ Module Structure

The module is organized into separate files for better maintainability:

```
├── cluster.tf          # EKS Cluster configuration
├── iam.tf             # IAM roles and policies
├── node_groups.tf     # EKS Node Groups
├── fargate.tf         # EKS Fargate Profiles
├── addons.tf          # EKS Add-ons (CoreDNS, VPC-CNI, etc.)
├── security_groups.tf # Security Groups
├── data.tf            # Data sources
├── locals.tf          # Local values
├── variables.tf       # Input variables
├── outputs.tf         # Output values
└── versions.tf        # Provider requirements
```

## ✨ Features

- ✅ **EKS Auto Mode** - Simplified cluster management with auto mode
- ✅ **Fargate Support** - Serverless container execution
- ✅ **Node Groups** - Managed EC2 instances for workloads
- ✅ **Essential Add-ons** - CoreDNS, VPC-CNI, Kube-proxy
- ✅ **Security Groups** - Flexible security group management
- ✅ **IAM Integration** - Proper IAM roles and policies
- ✅ **CloudWatch Logging** - Comprehensive cluster logging
- ✅ **Encryption** - Support for encryption at rest
- ✅ **Multi-AZ Support** - High availability deployment

## 🚀 Quick Start

### 1. Basic EKS Cluster with Node Groups

```hcl
module "eks" {
  source = "navjotdevops/eks/aws"

  cluster_name = "my-eks-cluster"
  vpc_id       = "vpc-12345678"
  subnet_ids   = ["subnet-12345678", "subnet-87654321"]

  node_groups = {
    main = {
      subnet_ids     = ["subnet-12345678", "subnet-87654321"]
      instance_types = ["t3.medium"]
      desired_size   = 2
      max_size       = 4
      min_size       = 1
    }
  }

  tags = {
    Environment = "production"
    Project     = "my-app"
  }
}
```

### 2. EKS with Auto Mode (Simplified Management)

```hcl
module "eks" {
  source = "navjotdevops/eks/aws"

  cluster_name = "my-auto-eks-cluster"
  vpc_id       = "vpc-12345678"
  subnet_ids   = ["subnet-12345678", "subnet-87654321"]

  # Enable EKS Auto Mode
  cluster_compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }

  tags = {
    Environment = "production"
    Project     = "my-app"
  }
}
```

### 3. EKS with Fargate Profiles

```hcl
module "eks" {
  source = "navjotdevops/eks/aws"

  cluster_name = "my-fargate-cluster"
  vpc_id       = "vpc-12345678"
  subnet_ids   = ["subnet-12345678", "subnet-87654321"]

  fargate_profiles = {
    default = {
      subnet_ids = ["subnet-12345678", "subnet-87654321"]
      selectors = [
        {
          namespace = "default"
        },
        {
          namespace = "kube-system"
          labels = {
            k8s-app = "kube-dns"
          }
        }
      ]
    }
  }

  tags = {
    Environment = "production"
    Project     = "my-app"
  }
}
```

### 4. Comprehensive EKS Setup

```hcl
module "eks" {
  source = "navjotdevops/eks/aws"

  cluster_name    = "comprehensive-eks"
  cluster_version = "1.28"
  vpc_id          = "vpc-12345678"
  subnet_ids      = ["subnet-12345678", "subnet-87654321"]

  # Cluster access configuration
  cluster_access_config = {
    authentication_mode                         = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }

  # Node Groups
  node_groups = {
    general = {
      subnet_ids     = ["subnet-12345678", "subnet-87654321"]
      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"
      desired_size   = 2
      max_size       = 4
      min_size       = 1
      
      labels = {
        role = "general"
      }
    }
    
    spot = {
      subnet_ids     = ["subnet-12345678", "subnet-87654321"]
      instance_types = ["t3.medium", "t3.large"]
      capacity_type  = "SPOT"
      desired_size   = 1
      max_size       = 3
      min_size       = 0
      
      labels = {
        role = "spot"
      }
      
      taints = [
        {
          key    = "spot"
          value  = "true"
          effect = "NO_SCHEDULE"
        }
      ]
    }
  }

  # Fargate Profiles
  fargate_profiles = {
    kube_system = {
      subnet_ids = ["subnet-12345678", "subnet-87654321"]
      selectors = [
        {
          namespace = "kube-system"
        }
      ]
    }
  }

  # Custom Add-ons
  cluster_addons = {
    coredns = {
      addon_version = "v1.10.1-eksbuild.1"
    }
    vpc-cni = {
      addon_version = "v1.15.1-eksbuild.1"
    }
    kube-proxy = {
      addon_version = "v1.28.1-eksbuild.1"
    }
    aws-ebs-csi-driver = {
      addon_version = "v1.24.0-eksbuild.1"
    }
  }

  # Security
  create_cluster_security_group = true
  cluster_security_group_additional_rules = [
    {
      description = "Allow HTTPS from office"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      type        = "ingress"
      cidr_blocks = ["10.0.0.0/8"]
    }
  ]

  # Logging
  cluster_enabled_log_types = ["api", "audit", "authenticator"]
  cloudwatch_log_group_retention_in_days = 30

  tags = {
    Environment = "production"
    Project     = "comprehensive-app"
    ManagedBy   = "terraform"
  }
}
```

## 📋 Requirements

| Name | Version |
|------|---------||
| terraform | >= 1.0 |
| aws | >= 5.0 |

## 🔧 Configuration Options

### EKS Auto Mode

Enable simplified cluster management:

```hcl
cluster_compute_config = {
  enabled    = true
  node_pools = ["general-purpose", "system"]
}
```

### Node Groups

Configure managed node groups:

```hcl
node_groups = {
  main = {
    subnet_ids     = ["subnet-12345"]
    instance_types = ["t3.medium"]
    capacity_type  = "ON_DEMAND"  # or "SPOT"
    desired_size   = 2
    max_size       = 4
    min_size       = 1
    
    # Optional configurations
    ami_type          = "AL2_x86_64"
    disk_size         = 20
    kubernetes_version = "1.28"
    
    labels = {
      role = "worker"
    }
    
    taints = [
      {
        key    = "dedicated"
        value  = "true"
        effect = "NO_SCHEDULE"
      }
    ]
  }
}
```

### Fargate Profiles

Configure serverless pod execution:

```hcl
fargate_profiles = {
  default = {
    subnet_ids = ["subnet-12345"]
    selectors = [
      {
        namespace = "default"
        labels = {
          app = "web"
        }
      }
    ]
  }
}
```

### Add-ons

Manage EKS add-ons:

```hcl
cluster_addons = {
  coredns = {
    addon_version = "v1.10.1-eksbuild.1"
    resolve_conflicts = "OVERWRITE"
  }
  vpc-cni = {
    addon_version = "v1.15.1-eksbuild.1"
    configuration_values = jsonencode({
      env = {
        ENABLE_PREFIX_DELEGATION = "true"
      }
    })
  }
  aws-ebs-csi-driver = {
    addon_version = "v1.24.0-eksbuild.1"
  }
}
```

## 📊 Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster_name | Name of the EKS cluster | `string` | n/a | yes |
| vpc_id | ID of the VPC | `string` | n/a | yes |
| subnet_ids | List of subnet IDs | `list(string)` | n/a | yes |
| cluster_version | Kubernetes version | `string` | `null` | no |
| node_groups | Map of node group definitions | `map(object)` | `{}` | no |
| fargate_profiles | Map of Fargate profile definitions | `map(object)` | `{}` | no |
| cluster_addons | Map of cluster addon configurations | `map(object)` | `{}` | no |
| enable_default_addons | Enable default addons | `bool` | `true` | no |
| cluster_compute_config | EKS Auto Mode configuration | `object` | `null` | no |
| tags | Tags to assign to resources | `map(string)` | `{}` | no |

## 📤 Outputs

| Name | Description |
|------|-------------|
| cluster_id | The ID of the EKS cluster |
| cluster_arn | The ARN of the cluster |
| cluster_endpoint | Endpoint for Kubernetes API server |
| cluster_version | The Kubernetes server version |
| cluster_security_group_id | Cluster security group ID |
| node_groups | Map of node group attributes |
| fargate_profiles | Map of Fargate profile attributes |
| cluster_addons | Map of cluster addon attributes |

## 🔍 Best Practices

### 1. Security

```hcl
# Use private endpoints
cluster_endpoint_private_access = true
cluster_endpoint_public_access  = false

# Restrict public access
cluster_endpoint_public_access_cidrs = ["10.0.0.0/8"]

# Enable logging
cluster_enabled_log_types = ["api", "audit", "authenticator"]
```

### 2. High Availability

```hcl
# Use multiple AZs
subnet_ids = ["subnet-1a", "subnet-1b", "subnet-1c"]

# Configure node groups across AZs
node_groups = {
  main = {
    subnet_ids = ["subnet-1a", "subnet-1b", "subnet-1c"]
    min_size   = 3  # At least one per AZ
  }
}
```

### 3. Cost Optimization

```hcl
# Use Spot instances for non-critical workloads
node_groups = {
  spot = {
    capacity_type = "SPOT"
    instance_types = ["t3.medium", "t3.large", "t2.medium"]
  }
}

# Use Fargate for intermittent workloads
fargate_profiles = {
  batch = {
    selectors = [{
      namespace = "batch"
    }]
  }
}
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Authors

- **[navjotdevops](https://github.com/navjotdevops)** - *Initial work*

## 📝 Changelog

See [CHANGELOG.md](CHANGELOG.md) for a list of changes and version history.

## 🆘 Support

If you have questions or need help:

1. Review the [documentation](#-inputs)
2. Check the [examples](#-quick-start)
3. Open an [issue](https://github.com/navjotdevops/terraform-aws-eks/issues)

---

⭐ **Star this repository if it helped you!**