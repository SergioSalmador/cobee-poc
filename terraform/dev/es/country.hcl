locals {
  country = "es"

  aws_region = "eu-west-1"
  azs        = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]

  cidr            = "10.10.0.0/16"
  private_subnets = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
  public_subnets  = ["10.10.101.0/24", "10.10.102.0/24", "10.10.103.0/24"]
}
