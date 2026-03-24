# VPC Outputs
output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_public_subnets" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnets
}

output "vpc_private_subnets" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnets
}

# EKS Outputs
output "eks_cluster_id" {
  description = "ID of the EKS cluster"
  value       = module.eks.cluster_id
}

output "eks_cluster_arn" {
  description = "ARN of the EKS cluster"
  value       = module.eks.cluster_arn
}

output "eks_cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_version" {
  description = "Kubernetes version of the EKS cluster"
  value       = module.eks.cluster_version
}

# OIDC Provider Outputs
output "oidc_provider_arn" {
  description = "ARN of the OIDC provider for EKS"
  value       = module.eks.oidc_provider_arn
}

output "oidc_provider_url" {
  description = "URL of the OIDC provider for EKS"
  value       = module.eks.oidc_provider_url
}

# IAM Role Outputs
output "platform_role_arn" {
  description = "ARN of the platform IAM role"
  value       = module.iam.platform_role_arn
}

output "eks_service_account_role_arn" {
  description = "ARN of the EKS service account IAM role for controllers"
  value       = module.iam.eks_service_account_role_arn
}

