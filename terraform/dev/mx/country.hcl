locals {
  country = "mx"

  aws_region = "us-east-1"
  azs        = ["us-east-1a", "us-east-1b", "us-east-1c"]

  cidr            = "10.20.0.0/16"
  private_subnets = ["10.20.1.0/24", "10.20.2.0/24", "10.20.3.0/24"]
  public_subnets  = ["10.20.101.0/24", "10.20.102.0/24", "10.20.103.0/24"]
}
