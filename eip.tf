resource "aws_eip" "lb" {
  instance = aws_instance.app-server[0].id

}