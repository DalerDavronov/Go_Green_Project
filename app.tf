resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true
    
    tags = {
        Name = "Main VPC"
    }
}

resource "aws_security_group" "server_sg" {
  name        = "server-sg"
  vpc_id      = aws_vpc.main.id
}
resource "aws_cloudwatch_metric_alarm" "cloud_watch" {
  alarm_name                = "terraform-test-cloud_watch"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 120
  statistic                 = "Average"
  threshold                 = 85
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []
  actions_enabled           = true
  alarm_actions             = [aws_autoscaling_policy.app_server_scaling_policy.arn]
}
resource "aws_launch_configuration" "app_server_launch_config" {
  name = "app-server-launch-config"
  image_id        = var.ami
  instance_type   = "t2.micro"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_subnet" "subnet_private_1a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-1b"
}

resource "aws_subnet" "subnet_private_1b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-west-1c"
}
resource "aws_instance" "app-server" {
  count         = aws_autoscaling_group.app_server_autoscaling_group.desired_capacity
  ami           = var.ami
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet_private_1a.id
  tags = {
    Name = "app-server-${count.index + 1}"
  }
  user_data = <<-EOF
    !/bin/bash -ex

    # Update the system
    sudo dnf -y update

    # Install MySQL Community Server
    sudo dnf -y install https://dev.mysql.com/get/mysql80-community-release-el9-1.noarch.rpm
    sudo dnf -y install mysql-community-server

    # Start and enable MySQL
    sudo systemctl start mysqld
    sudo systemctl enable mysqld

    # Install Apache and PHP
    sudo dnf -y install httpd php

    # Start and enable Apache
    sudo systemctl start httpd
    sudo systemctl enable httpd

    # Navigate to the HTML directory
    cd /var/www/html

    # Download and extract a compressed file
    sudo wget https://aws-tc-largeobjects.s3-us-west-2.amazonaws.com/CUR-TF-200-ACACAD/studentdownload/lab-app.tgz
    sudo tar xvfz lab-app.tgz

    # Change ownership of a file
    sudo chown apache:root /var/www/html/rds.conf.php
  EOF 
} 
resource "aws_autoscaling_group" "app_server_autoscaling_group" {
  desired_capacity     = 2
  max_size             = 5
  min_size             = 1
  vpc_zone_identifier = [aws_subnet.subnet_private_1a.id, aws_subnet.subnet_private_1b.id]
  launch_configuration = aws_launch_configuration.app_server_launch_config.id
  health_check_type          = "EC2"
  health_check_grace_period  = 300

  force_delete = true
  tag {
    key                 = "Name"
    value               = "app-server"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_autoscaling_policy" "app_server_scaling_policy" {
  name                   = "app-server-scaling-policy"
  scaling_adjustment    = 1
  adjustment_type       = "ChangeInCapacity"
  cooldown              = 300  
  autoscaling_group_name = aws_autoscaling_group.app_server_autoscaling_group.name
}
resource "aws_lb" "app-server_lb" {
  name               = "App-Server-LB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.server_sg.id]
  subnet_mapping {
    subnet_id = aws_subnet.subnet_private_1a.id
  }
  subnet_mapping {
    subnet_id = aws_subnet.subnet_private_1b.id
  }
  tags = {
    Environment = "production"
  }
}
output "private_ip_address" {
  value = aws_instance.app-server[*].private_ip
}
