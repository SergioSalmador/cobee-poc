module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = "${var.db_identifier}-rds-sg"
  description = "PostgreSQL security group for ${var.db_identifier}"
  vpc_id      = var.vpc_id

  ingress_with_source_security_group_id = [
    for sg_id in var.eks_node_security_group_ids : {
      from_port                = 5432
      to_port                  = 5432
      protocol                 = "tcp"
      description              = "PostgreSQL access from EKS nodes"
      source_security_group_id = sg_id
    }
  ]

  egress_rules = ["all-all"]

  tags = merge(var.tags, {
    Name = "${var.db_identifier}-rds-sg"
  })
}
