resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  instance_tenancy = "default"

  tags = local.vpc_final_tags
}

resource "aws_internet_gateway" "name" {
  vpc_id = aws_vpc.main.id
  tags = local.igw_final_tags
}