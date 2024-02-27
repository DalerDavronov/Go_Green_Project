resource "aws_nat_gateway" "NAT" {
  allocation_id = aws_eip.lb.id
  subnet_id     = aws_subnet.subnet_private_1a.id

  tags = {
    Name = "NAT"
  }
}