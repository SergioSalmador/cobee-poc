locals {
  country = "mx"

  aws_region = "us-east-1"
  azs        = ["us-east-1a", "us-east-1b", "us-east-1c"]

  cidr            = "10.120.0.0/16"
  private_subnets = ["10.120.1.0/24", "10.120.2.0/24", "10.120.3.0/24"]
  public_subnets  = ["10.120.101.0/24", "10.120.102.0/24", "10.120.103.0/24"]
}
