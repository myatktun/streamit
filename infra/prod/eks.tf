module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.0.4"

  cluster_name    = var.eks_cluster
  cluster_version = "1.23"

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
  enable_irsa                     = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_group_defaults = {
    ami_type                              = "AL2_x86_64"
    attach_cluster_primary_security_group = true
    create_security_group                 = false
    vpc_security_group_ids                = [aws_security_group.node_group.id]
  }

  eks_managed_node_groups = {
    general = {
      name = "${var.project_name}-node-group"

      instance_types = ["t2.small"]
      min_size       = 1
      max_size       = 1
      desired_size   = 1
      capacity_type  = "ON_DEMAND"
    }
  }

  node_security_group_tags = {
    "kubernetes.io/cluster/${var.eks_cluster}" = null
  }

  tags = {
    Name = "${var.eks_cluster}"
  }
}
