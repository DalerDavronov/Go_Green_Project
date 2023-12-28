resource "aws_instance" "app_server_a" {
  ami                    = var.ami
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.subnet_private_1a.id
  vpc_security_group_ids = [aws_security_group.server_sg.id]  

  tags = {
    Name = "app-tier-west-1a"
  }
}
resource "aws_instance" "app_server_b" {
  ami                    = var.ami
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.subnet_private_1b.id
  vpc_security_group_ids = [aws_security_group.server_sg.id]  

  tags = {
    Name = "app-tier-west-1b"
  }
}

resource "aws_subnet" "subnet_private_1a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-1b"  

  tags = {
    Name = "subnet-1a"
  }
}

resource "aws_subnet" "subnet_private_1b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-west-1c"  

  tags = {
    Name = "subnet-1b"
  }
}
resource "aws_network_interface" "app_server_nic_1" {
  subnet_id       = aws_subnet.subnet_private_1a.id
  security_groups = [aws_security_group.server_sg.id]
}

resource "aws_network_interface" "app_server_nic_2" {
  subnet_id       = aws_subnet.subnet_private_1b.id
  security_groups = [aws_security_group.server_sg.id]
}


resource "aws_lb" "app_server_lb" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.server_sg.id]
  enable_cross_zone_load_balancing = true
  enable_http2 = true
  subnets = [aws_subnet.subnet_private_1a.id, aws_subnet.subnet_private_1b.id]
}
resource "aws_lb_target_group" "app_server_target_group" {
  name     = "app-server-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_target_group_attachment" "app_server1a_attachment" {
  target_group_arn = aws_lb_target_group.app_server_target_group.arn
  target_id        = aws_instance.app_server_a.id
}

resource "aws_lb_target_group_attachment" "app_server1b_attachment" {
  target_group_arn = aws_lb_target_group.app_server_target_group.arn
  target_id        = aws_instance.app_server_b.id
}