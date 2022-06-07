module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.VPC_NAME
  cidr = var.VPC_CIDR # 10.0.0.0/8 is reserved for EC2-Classic

  azs                 = [var.ZONE1, var.ZONE2, var.ZONE3]
  private_subnets     = [var.PRIV1_CIDR, var.PRIV2_CIDR, var.PRIV3_CIDR]
  public_subnets      = [var.PUB1_CIDR,var.PUB2_CIDR,var.PUB3_CIDR]

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Terraform = "true"
  }
  vpc_tags = {
    Name = var.VPC_NAME
  }
}