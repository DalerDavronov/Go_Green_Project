resource "aws_eip" "nat1" {
  depends_on = [aws_internet_gateway.igw]
  domain = aws_vpc.main.id
}