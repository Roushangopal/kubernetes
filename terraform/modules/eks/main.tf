module "eks" {
  source = "terraform-aws-modules/eks/aws"

  name    = "${var.project_name}-eks"
  version = "21.0.9"

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnets
  kubernetes_version = "1.27"

  enable_irsa = true

  eks_managed_node_groups = {
    eks_nodes = {
      name            = "eks-node-group"
      use_name_prefix = true

      capacity_type  = "ON_DEMAND"
      disk_size      = 50
      desired_size   = 2
      max_size       = 3
      min_size       = 1

      instance_types = ["t3.medium"]

      key_name = var.key_pair_name

      tags = {
        Project = var.project_name
      }
    }
  }

  tags = {
    Project = var.project_name
  }
}
