resource "aws_kms_key" "keymanagementservice" {
  description             = "KMS key 1"
  deletion_window_in_days = 30
}