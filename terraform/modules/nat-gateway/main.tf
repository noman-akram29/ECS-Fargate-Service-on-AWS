data "aws_vpc" "selected" {
  id = var.vpc_id
}

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = merge(var.tags, {
    Name = "${var.environment}-nat-eip"
  })
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = var.public_subnet_id

  tags = merge(var.tags, {
    Name = "${var.environment}-nat-gateway"
  })

  depends_on = [aws_eip.nat]
}

resource "aws_route_table" "private" {
  vpc_id = data.aws_vpc.selected.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }

  tags = merge(var.tags, {
    Name = "${var.environment}-private-rt"
  })
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_ids)
  subnet_id      = var.private_subnet_ids[count.index]
  route_table_id = aws_route_table.private.id
}