module "bastion" {
  source = "umotif-public/bastion/aws"
  version = "~> 2.1.0"
  name_prefix = var.prefix
  vpc_id         = aws_vpc.main.id
  public_subnets = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id] 
  private_subnets = [aws_subnet.subnet_private_1b.id]
  ssh_key_name   = aws_key_pair.key.key_name_prefix
  tags = {
    Project = "GoGreen"
  }
}