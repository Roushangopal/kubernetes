# 🚀 Kubernetes Platform with Terraform & AWS

This repository contains Terraform infrastructure as code to bootstrap a production-ready Kubernetes platform on AWS using EKS.

## ⚠️ Current Status

✅ **Infrastructure Implemented:**
- AWS VPC with public/private subnets
- EKS management cluster with managed node groups
- IAM roles with OIDC provider for IRSA (IAM Roles for Service Accounts)
- RDS database instance
- Security groups and networking

## 📌 Architecture Overview

### Components Created

1. **VPC Module** (`terraform/modules/vpc/`)
   - VPC with configurable CIDR (default: 10.0.0.0/16)
   - Public and private subnets across multiple availability zones
   - NAT Gateway for private subnet egress
   - DNS hostnames and DNS support enabled

2. **EKS Module** (`terraform/modules/eks/`)
   - EKS Kubernetes cluster (v1.31)
   - Managed node groups with auto-scaling (2-3 nodes, t3.medium)
   - IRSA enabled for IAM Roles for Service Accounts
   - Cluster endpoint for kubectl access

3. **IAM Module** (`terraform/modules/iam/`)
   - Platform base role with trust relationship to EKS
   - Service account role for Kubernetes controllers
   - OIDC provider integration for federated identity


5. **OIDC Provider** (Auto-created by EKS)
   - Enables IRSA for pod authentication
   - Allows Kubernetes service accounts to assume AWS IAM roles

## 📁 Repository Structure

```
terraform/
├── main.tf                    # Root module orchestration
├── variables.tf              # Input variables (region, project_name, etc.)
├── providers.tf              # AWS provider configuration
├── outputs.tf                # Root outputs (cluster ID, OIDC ARN, etc.)
├── terraform.tfvars          # Terraform variable values (EDIT THIS)
├── terraform.tfvars.example  # Example configuration template
└── modules/
    ├── vpc/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── eks/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── iam/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── rds/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

## 🔧 Prerequisites

- Terraform >= 1.5.0
- AWS CLI configured with credentials
- kubectl installed
- An EC2 Key Pair in your target AWS region

## 🚀 Quick Start

### 1. Configure Variables

Edit `terraform/terraform.tfvars` with your values:

```hcl
region                = "us-east-1"
project_name          = "my-platform"
key_pair_name         = "your-ec2-keypair"  # Must exist in AWS
db_name               = "appdb"
db_username           = "admin"
db_password           = "YourSecurePassword123!"
```

### 2. Initialize Terraform

```bash
cd terraform/
terraform init
```

### 3. Review Changes

```bash
terraform plan
```

### 4. Apply Infrastructure

```bash
terraform apply
```

### 5. Configure kubectl

```bash
aws eks update-kubeconfig --name <project-name>-eks --region <region>
kubectl get nodes
```

## 📊 Outputs

After successful deployment, retrieve important values:

```bash
# Get cluster information
terraform output eks_cluster_id
terraform output eks_cluster_endpoint

# Get OIDC provider details (for IRSA setup)
terraform output oidc_provider_arn
terraform output oidc_provider_url

# Get IAM roles for service accounts
terraform output eks_service_account_role_arn

# Get RDS endpoint
terraform output rds_db_endpoint
```

## 🔐 Security Features

- **IRSA Integration**: Pods can assume IAM roles via OIDC provider
- **Private Subnets**: Nodes run in private subnets with NAT gateway
- **Security Groups**: RDS only accessible from EKS nodes
- **Managed IAM**: Uses managed policies and least privilege access
- **Network Isolation**: VPC with CIDR blocking and subnet separation

## 📝 Variables Reference

### Root Variables (`terraform/variables.tf`)

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `region` | string | `us-east-1` | AWS region |
| `project_name` | string | - | Project name prefix for resources |
| `vpc_cidr` | string | `10.0.0.0/16` | VPC CIDR block |
| `availability_zones` | list | `[us-east-1a, us-east-1b]` | Availability zones for subnets |
| `public_subnets` | list | `[10.0.1.0/24, 10.0.2.0/24]` | Public subnet CIDRs |
| `private_subnets` | list | `[10.0.101.0/24, 10.0.102.0/24]` | Private subnet CIDRs |
| `key_pair_name` | string | - | EC2 Key Pair name for node access |

## 🔄 Next Steps

1. **Deploy Add-ons**: Install AWS Load Balancer Controller, Cluster Autoscaler, etc.
2. **Setup RBAC**: Configure Kubernetes RBAC policies
3. **Deploy Applications**: Use Cluster API and AWS Cloud Control Manager
4. **Implement Monitoring**: Setup CloudWatch, Prometheus, or other monitoring solutions
5. **Enable CI/CD**: Integrate with GitOps tools (ArgoCD, Flux, etc.)

## 📚 Module Details

### VPC Module
- Creates networking infrastructure
- Enables NAT Gateway for high availability (single_nat_gateway)
- Tags all resources with project name

### EKS Module
- Deploys EKS cluster with managed control plane
- Configures managed node groups with auto-scaling
- Enables IRSA for IAM integration
- Outputs cluster endpoint and security group info

### IAM Module
- Creates platform base role
- Creates service account role for IRSA
- Outputs role ARNs for Kubernetes service account annotations

### RDS Module
- Provisions managed MySQL/PostgreSQL database
- Places in private subnets for security
- Allows traffic only from EKS nodes
- Outputs database endpoint for applications

```

### Key pair not found
```bash
# Create or verify key pair exists
aws ec2 describe-key-pairs --region us-east-1
```

### kubectl: Unable to connect to cluster
```bash
# Update kubeconfig
aws eks update-kubeconfig --name <cluster-name> --region <region>
```

### Database connection timeout
```bash
# Verify RDS security group allows EKS node traffic
aws ec2 describe-security-groups --filter Name=group-name,Values="<project>-rds-sg"
```

## 🛠️ Maintenance

##If using RDS, verify security group configuration
# For this version, RDS has been removed from core infrastructure
```hcl
desired_size = 3  # Change desired capacity
max_size     = 5  # Change max capacity
```

### Upgrading Kubernetes
Update cluster_version in `terraform/modules/eks/main.tf`:
```hcl
cluster_version = "1.32"  # Use newer version
```

## 📖 Additional Resources

- [AWS EKS Documentation](https://docs.aws.amazon.com/eks/)
- [Terraform AWS Modules](https://registry.terraform.io/modules/terraform-aws-modules/)
- [EKS Best Practices](https://aws.github.io/aws-eks-best-practices/)

## 📄 License

This infrastructure code is provided as-is for educational and production use.

