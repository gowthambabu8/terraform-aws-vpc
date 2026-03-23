resource "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project}/${var.environment}/vpc_id"
  type="String"
  value = aws_vpc.main.id
}

resource "aws_ssm_parameter" "public_subnet" {
  name = "/${var.project}/${var.environment}/public_subnet"
  type = "StringList"
  value = join(",",aws_subnet.public[*].id)
}

resource "aws_ssm_parameter" "private_subnet" {
  name = "/${var.project}/${var.environment}/private_subnet"
  type = "StringList"
  value = join(",",aws_subnet.private[*].id)
}

resource "aws_ssm_parameter" "database_subnet" {
  name = "/${var.project}/${var.environment}/database_subnet"
  type = "StringList"
  value = join(",",aws_subnet.database[*].id)
}