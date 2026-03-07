remote_state {
  backend = "s3"

  config = {
    bucket         = "go-webapp-terraform-state"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "eu-west-1"
    encrypt        = true
    dynamodb_table = "go-webapp-terraform-locks"
  }
}
