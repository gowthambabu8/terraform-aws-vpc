resource "aws_vpc_peering_connection" "main" {
    count = var.is_peering_required ? 1 : 0
    # Requestor
    vpc_id = aws_vpc.main.id
    # Acceptor
    peer_vpc_id = data.aws_vpc.default.id

    accepter {
      allow_remote_vpc_dns_resolution = true
    }

    requester {
      allow_remote_vpc_dns_resolution = true
    }
    auto_accept = true
}

# vpc peering public route
resource "aws_route" "public_peering" {
  count = var.is_peering_required ? 1: 0
  route_table_id = aws_route_table.public.id
  destination_cidr_block = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.main[count.index].id
}

# vpc peering private route
resource "aws_route" "private_peering" {
  count = var.is_peering_required ? 1: 0
  route_table_id = aws_route_table.private.id
  destination_cidr_block = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.main[count.index].id
}

# vpc peering database route
resource "aws_route" "database_peering" {
  count = var.is_peering_required ? 1: 0
  route_table_id = aws_route_table.database.id
  destination_cidr_block = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.main[count.index].id
}

# vpc peering route
resource "aws_route" "default_peering" {
  count = var.is_peering_required ? 1: 0
  route_table_id = data.aws_route_table.default.id
  destination_cidr_block = var.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.main[count.index].id
}