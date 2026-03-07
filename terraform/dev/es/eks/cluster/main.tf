locals {
  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Allow node-to-node communication inside the EKS cluster"
      protocol    = var.node_sg_rule_ingress_self_all_protocol
      from_port   = var.node_sg_rule_ingress_self_all_from_port
      to_port     = var.node_sg_rule_ingress_self_all_to_port
      type        = var.node_sg_rule_ingress_self_all_type
      self        = var.node_sg_rule_ingress_self_all_self
    }

    ingress_app_from_alb = {
      description              = "Allow app traffic from ALB SG"
      protocol                 = "tcp"
      from_port                = var.app_port
      to_port                  = var.app_port
      type                     = "ingress"
      source_security_group_id = aws_security_group.alb.id
    }
  }
}

module "eks_admin_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "~> 5.0"

  create_role       = var.create_admin_role
  role_name         = "${var.eks_cluster_name}-eks-admin"
  role_requires_mfa = var.admin_role_requires_mfa

  trusted_role_arns       = var.trusted_role_arns
  custom_role_policy_arns = var.custom_admin_role_policy_arns

  tags = var.tags
}

module "eks_readonly_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "~> 5.0"

  create_role       = var.create_readonly_role
  role_name         = "${var.eks_cluster_name}-eks-readonly"
  role_requires_mfa = var.admin_role_requires_mfa

  trusted_role_arns       = var.trusted_role_arns
  custom_role_policy_arns = var.custom_readonly_role_policy_arns

  tags = var.tags
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.15.1"

  name                         = var.eks_cluster_name
  kubernetes_version           = var.eks_cluster_version
  enable_irsa                  = var.eks_enable_irsa
  create_iam_role              = var.create_admin_role
  endpoint_public_access       = var.eks_cluster_endpoint_public_access
  endpoint_public_access_cidrs = var.eks_cluster_endpoint_public_access_cidrs

  vpc_id     = var.eks_vpc_id
  subnet_ids = var.eks_subnet_ids

  eks_managed_node_groups = var.eks_managed_node_groups

  node_security_group_additional_rules = local.node_security_group_additional_rules

  access_entries = {
    eks-admin = {
      principal_arn = module.eks_admin_role.iam_role_arn
      policy_associations = {
        admin = {
          policy_arn = var.eks_access_entry_admin_policy_arn
          access_scope = {
            type = "cluster"
          }
        }
      }
    }

    eks-readonly = {
      principal_arn = module.eks_readonly_role.iam_role_arn
      policy_associations = {
        view = {
          policy_arn = var.eks_access_entry_view_policy_arn
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }

  tags = merge(var.tags, {
    Name = var.eks_cluster_name
  })
}
