data "aws_iam_policy_document" "go_webapp_secret_read" {
  statement {
    sid    = "ReadRdsMasterSecret"
    effect = "Allow"

    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret"
    ]

    resources = var.secret_arns
  }
}

resource "aws_iam_policy" "go_webapp_secret_read" {
  name_prefix = "${var.role_name}-secret-read-"
  description = "Allow go-webapp to read database credentials from Secrets Manager"
  policy      = data.aws_iam_policy_document.go_webapp_secret_read.json

  tags = var.tags
}

module "go_webapp_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "~> 5.0"

  create_role = true
  role_name   = var.role_name

  provider_url = var.oidc_provider

  oidc_fully_qualified_subjects = [
    "system:serviceaccount:${var.service_account_namespace}:${var.service_account_name}"
  ]

  role_policy_arns = [aws_iam_policy.go_webapp_secret_read.arn]

  tags = var.tags
}
