output "go_webapp_irsa_role_arn" {
  value = module.go_webapp_irsa_role.iam_role_arn
}

output "go_webapp_irsa_role_name" {
  value = module.go_webapp_irsa_role.iam_role_name
}

output "go_webapp_secret_read_policy_arn" {
  value = aws_iam_policy.go_webapp_secret_read.arn
}
