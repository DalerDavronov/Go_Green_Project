resource "aws_db_instance" "rds" {
  allocated_storage    = 100
  db_name              = "mydatabase"
  engine               = "mysql"
  engine_version       = "5.7.22"
  instance_class       = "db.t3.micro"
  username             = "admin"
  password             = "password"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
}
resource "aws_s3_bucket" "s3-bucket" {
  bucket = "my-tf-test-bucket"

  tags = {
    Name        = "My S3-Bucket"
    Environment = "Dev"
  }
}