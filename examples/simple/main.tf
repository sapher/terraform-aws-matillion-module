locals {
  region = "eu-west-1"
}

provider "aws" {
  region = local.region
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "vpc-test"
  cidr = "10.0.0.0/16"

  azs            = ["${local.region}a", "${local.region}b"]
  public_subnets = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false
}

module "matillion" {
  source            = "../.."
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnets
  region            = local.region
}
