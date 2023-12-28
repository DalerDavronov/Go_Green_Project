resource "aws_instance" "web_server_a" {
  ami                    = var.ami
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.subnet_1a.id
  vpc_security_group_ids = [aws_security_group.server_sg.id]  

  tags = {
    Name = "Web-tier-west-1a"
  }
}
resource "aws_instance" "web_server_b" {
  ami                    = var.ami
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.subnet_1b.id
  vpc_security_group_ids = [aws_security_group.server_sg.id]  

  tags = {
    Name = "Web-tier-west-1b"
  }
}

resource "aws_subnet" "subnet_1a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-1b"  

  tags = {
    Name = "subnet-1a"
  }
}

resource "aws_subnet" "subnet_1b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-west-1c"  

  tags = {
    Name = "subnet-1b"
  }
}
resource "aws_network_interface" "web_server_nic_1" {
  subnet_id       = aws_subnet.subnet_1a.id
  security_groups = [aws_security_group.server_sg.id]
}

resource "aws_network_interface" "web_server_nic_2" {
  subnet_id       = aws_subnet.subnet_1b.id
  security_groups = [aws_security_group.server_sg.id]
}


resource "aws_lb" "web_server_lb" {
  name               = "web-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.server_sg.id]
  enable_cross_zone_load_balancing = true
  enable_http2 = true
  subnets = [aws_subnet.subnet_1a.id, aws_subnet.subnet_1b.id]
}
resource "aws_lb_target_group" "web_server_target_group" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_target_group_attachment" "web_server_a_attachment" {
  target_group_arn = aws_lb_target_group.web_server_target_group.arn
  target_id        = aws_instance.web_server_a.id
}

resource "aws_lb_target_group_attachment" "web_server_b_attachment" {
  target_group_arn = aws_lb_target_group.web_server_target_group.arn
  target_id        = aws_instance.web_server_b.id
}