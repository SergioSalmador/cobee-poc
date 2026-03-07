variable "role_name" {
  type = string
}

variable "oidc_provider" {
  type = string
}

variable "service_account_namespace" {
  type = string
}

variable "service_account_name" {
  type = string
}

variable "secret_arns" {
  type = list(string)
}

variable "tags" {
  type = map(string)
}
