# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-06-26

### Added
- Initial release of the Terraform AWS EKS module
- EKS Cluster creation and management with flexible configuration
- Support for EKS Auto Mode for simplified cluster management
- EKS Node Groups with comprehensive configuration options
- EKS Fargate Profiles for serverless container execution
- Essential EKS Add-ons management (CoreDNS, VPC-CNI, Kube-proxy)
- IAM roles and policies for cluster, node groups, and Fargate
- Security groups management with additional rules support
- CloudWatch logging with configurable retention
- Encryption support for cluster data
- Multi-AZ deployment support
- Comprehensive input validation and output values

### Features
- **EKS Auto Mode**: Simplified cluster management with automatic node provisioning
- **Flexible Compute**: Choose between node groups, Fargate, or both
- **Essential Add-ons**: Automatic installation of CoreDNS, VPC-CNI, and Kube-proxy
- **Security**: Comprehensive IAM roles and security group management
- **Monitoring**: CloudWatch logging and Container Insights support
- **High Availability**: Multi-AZ support with proper subnet distribution
- **Cost Optimization**: Support for Spot instances and Fargate
- **Customization**: Extensive configuration options for all components

### Module Structure
- **cluster.tf**: EKS cluster configuration and CloudWatch logging
- **iam.tf**: IAM roles and policies for all EKS components
- **node_groups.tf**: Managed node groups with scaling and configuration
- **fargate.tf**: Fargate profiles for serverless workloads
- **addons.tf**: EKS add-ons management with version control
- **security_groups.tf**: Security groups and rules management
- **data.tf**: Data sources for AWS resources and EKS authentication
- **locals.tf**: Local values and computed configurations
- **variables.tf**: Input variables with comprehensive validation
- **outputs.tf**: Output values for integration with other modules
- **versions.tf**: Provider version requirements

### Configuration Options
- **Cluster Configuration**:
  - Kubernetes version selection
  - Endpoint access control (private/public)
  - Access configuration with authentication modes
  - Encryption at rest with KMS keys
  - Network configuration (IPv4/IPv6 support)
  - Comprehensive logging options

- **Node Groups**:
  - Multiple instance types and capacity types (On-Demand/Spot)
  - Auto Scaling configuration
  - Custom AMI and disk size options
  - Labels and taints support
  - Launch template integration
  - Remote access configuration

- **Fargate Profiles**:
  - Namespace and label selectors
  - Subnet configuration
  - Pod execution role management

- **Add-ons**:
  - Version management
  - Configuration values support
  - Conflict resolution strategies
  - Service account role integration

### Security Features
- Least privilege IAM roles for all components
- Security group management with custom rules
- Private endpoint support
- CIDR-based access control
- Encryption support for cluster data

### Documentation
- Comprehensive README with usage examples
- Input and output documentation
- Best practices guide
- Security recommendations
- Cost optimization strategies

### Examples
- Basic EKS cluster with node groups
- EKS Auto Mode configuration
- Fargate-only deployment
- Comprehensive multi-component setup
- Security-focused configuration
- Cost-optimized setup with Spot instances

## [Unreleased]

### Planned
- IRSA (IAM Roles for Service Accounts) support
- EKS Pod Identity integration
- Advanced networking configurations
- Cluster autoscaler integration
- Monitoring and observability enhancements
- Additional add-ons support (AWS Load Balancer Controller, etc.)
- Blue/Green deployment strategies
- Multi-cluster management features