resource "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project}/${var.environment}/vpc_id"
  type="String"
  value = var.vpc_id
}

resource "aws_ssm_parameter" "public_subnet" {
  name = "/${var.project}/${var.environment}/public_subnet"
  type = "StringList"
  value = join(",",var.public_subnet_cidr)
}

resource "aws_ssm_parameter" "private_subnet" {
  name = "/${var.project}/${var.environment}/private_subnet"
  type = "StringList"
  value = join(",",var.private_subnet_cidr)
}

resource "aws_ssm_parameter" "database_subnet" {
  name = "/${var.project}/${var.environment}/database_subnet"
  type = "StringList"
  value = join(",",var.database_subnet_cidr)
}