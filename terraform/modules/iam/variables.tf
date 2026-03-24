variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "oidc_provider_arn" {
  description = "ARN of the OIDC provider for EKS"
  type        = string
}

variable "oidc_provider_url" {
  description = "URL of the OIDC provider for EKS (without https://)"
  type        = string
}
