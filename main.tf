resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  instance_tenancy = "default"

  tags = local.vpc_final_tags
}

resource "aws_internet_gateway" "name" {
  vpc_id = aws_vpc.main.id
  tags = local.igw_final_tags
}

resource "aws_subnet" "name" {
  count = length(var.public_subnet_cidr)
  vpc_id = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr[count.index]
  availability_zone = local.azs_names[count.index]
  map_public_ip_on_launch = true
  # Name = roboshop-dev-public-us-east-1a
  tags = merge(
    local.subnet_final_tags,
    {
        Name = "${var.project}-${var.environment}-public-${local.azs_names[count.index]}"
    } )
}