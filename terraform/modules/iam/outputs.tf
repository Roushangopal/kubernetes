output "platform_role_arn" {
  description = "ARN of the platform IAM role"
  value       = aws_iam_role.platform_role.arn
}

output "platform_role_name" {
  description = "Name of the platform IAM role"
  value       = aws_iam_role.platform_role.name
}

output "eks_service_account_role_arn" {
  description = "ARN of the EKS service account IAM role"
  value       = aws_iam_role.eks_service_account_role.arn
}

output "eks_service_account_role_name" {
  description = "Name of the EKS service account IAM role"
  value       = aws_iam_role.eks_service_account_role.name
}
