resource "aws_iam_role" "platform_role" {
  name = "${var.project_name}-platform-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = ["eks.amazonaws.com", "ec2.amazonaws.com"]
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Service account role for EKS add-ons (e.g., aws-load-balancer-controller, cluster-autoscaler)
resource "aws_iam_role" "eks_service_account_role" {
  name = "${var.project_name}-eks-service-account-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = var.oidc_provider_arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${replace(var.oidc_provider_url, "https://", "")}:sub" = "system:serviceaccount:kube-system:eks-service-account"
          }
        }
      }
    ]
  })
}