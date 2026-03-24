variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "key_pair_name" {
  description = "Name of the EC2 Key Pair for EKS node access"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where EKS cluster will be deployed"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnet IDs for EKS nodes"
  type        = list(string)
}
