resource "aws_cloudwatch_log_group" "http_errors_log_group" {
  name = "/var/log/http_errors"
  retention_in_days = 7
}
resource "aws_cloudwatch_log_metric_filter" "http_errors_metric_filter" {
  name           = "http_errors_filter"
  pattern        = "400"
  log_group_name = aws_cloudwatch_log_group.http_errors_log_group.name

  metric_transformation {
    name      = "HTTP4xxErrors"
    namespace = "Go-green-web-tierApp"  
    value     = "1"
  }
}
resource "aws_cloudwatch_metric_alarm" "http_errors_alarm" {
  alarm_name          = "HTTP4xxErrorsAlarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "HTTP4xxErrors"
  namespace           = "Go-green-web-tierApp"  
  period              = 60 
  statistic           = "Sum"
  threshold           = 100
  alarm_description   = "HTTP 4xx Errors exceed 100 per minute"
  actions_enabled     = true

  alarm_actions = [aws_sns_topic.http_errors_sns_topic.arn]
}

resource "aws_launch_configuration" "web_launch_config" {
  name_prefix = "web-launch-config"
  image_id = var.ami
  instance_type = "t2.micro"
}
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-1b"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-west-1c"
  map_public_ip_on_launch = true
}
resource "aws_autoscaling_group" "web_asg" {
  desired_capacity     = 2  
  max_size             = 5 
  min_size             = 1  
  launch_configuration = aws_launch_configuration.web_launch_config.id
  vpc_zone_identifier  = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]  
}

resource "aws_lb" "web_lb" {
  name               = "web-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.server_sg.id]    

  enable_cross_zone_load_balancing = true  

  subnets = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]  
}

resource "aws_lb_target_group" "web_tg" {
  name        = "web-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.main.id
}

resource "aws_instance" "web_instance" {
  count         = aws_autoscaling_group.web_asg.desired_capacity
  ami           = var.ami 
  instance_type = "t2.micro"
  tags = {
    Name = "web-instance-${count.index + 1}"
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
output "public_ip_address" {
  value = aws_instance.web_instance[*].public_ip
}