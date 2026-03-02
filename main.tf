resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  instance_tenancy = "default"

  tags = local.vpc_final_tags
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = local.igw_final_tags
}

# public subnet
resource "aws_subnet" "public" {
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

# private subnet
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidr)
  vpc_id = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr[count.index]
  availability_zone = local.azs_names[count.index]
  map_public_ip_on_launch = false
  # Name = roboshop-dev-public-us-east-1a
  tags = merge(
    local.subnet_final_tags,
    {
        Name = "${var.project}-${var.environment}-private-${local.azs_names[count.index]}"
    } )
}

# database subnet
resource "aws_subnet" "database" {
  count = length(var.database_subnet_cidr)
  vpc_id = aws_vpc.main.id
  cidr_block = var.database_subnet_cidr[count.index]
  availability_zone = local.azs_names[count.index]
  map_public_ip_on_launch = false
  
  tags = merge(
    local.subnet_final_tags,
    {
        Name = "${var.project}-${var.environment}-database-${local.azs_names[count.index]}"
    } )
}

# public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-public"
    },
    var.public_route_table_tags
  )
}

# private route table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-private"
    },
    var.private_route_table_tags
  )
}

# database route table
resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-database"
    },
    var.database_route_table_tags
  )
}

# public route
resource "aws_route" "public" {
  route_table_id = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main.id
  depends_on = [ aws_internet_gateway.main ]
}

# EIP creation
resource "aws_eip" "nat" {
  domain = "vpc"
  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-nat"
    },
    var.nat_route_table_tags
  )
}

# NAT Gateway 
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.public[0].id # we are creating nat gateway in us-east1a
  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-nat"
    },
    var.nat_route_table_tags
  )
}

# private route
resource "aws_route" "private" {
  route_table_id = aws_route_table.private.id
  nat_gateway_id = aws_nat_gateway.main.id
  destination_cidr_block = "0.0.0.0/0"
  
}

# database route
resource "aws_route" "database" {
  route_table_id = aws_route_table.database.id
  nat_gateway_id = aws_nat_gateway.main.id
  destination_cidr_block = "0.0.0.0/0"
}

# public route table association
resource "aws_route_table_association" "public" {
  route_table_id = aws_route.public.id
  subnet_id = aws_subnet.public.id
}

# private route table association
resource "aws_route_table_association" "private" {
  route_table_id = aws_route.private.id
  subnet_id = aws_subnet.private.id
}

# database route table association
resource "aws_route_table_association" "database" {
  route_table_id = aws_route.database.id
  subnet_id = aws_subnet.database.id
}