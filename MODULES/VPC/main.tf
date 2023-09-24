resource "aws_vpc" "VPC-TF" {
  cidr_block       = var.VPC_cidr
  instance_tenancy = var.vpc_instance_tenancy
  enable_dns_hostnames = var.vpc_enable_dns_hostnames
  enable_dns_support   = var.vpc_enable_dns_support

  tags = merge(var.required_tags, {"Name" = "VPC-TF-Mod"} )
}