resource "aws_nat_gateway" "NAT" {
  allocation_id = aws_eip.nat1.id
  subnet_id     = aws_subnet.subnet_private_1a.id

  tags = {
    Name = "NAT"
  }

#   depends_on = [aws_internet_gateway.main]
}