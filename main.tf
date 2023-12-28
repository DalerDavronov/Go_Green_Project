resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true
    
    tags = {
        Name = "Main VPC"
    }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Main Igw"
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
}