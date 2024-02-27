# resource "aws_iam_group" "SysAdmin" {
#   name = "SysAdmin"
# }
 
# resource "aws_iam_user" "Sysadmin1" {
#   name = "Sysadmin1"
# }
 
# resource "aws_iam_user" "Sysadmin2" {
#   name = "Sysadmin2"
# }
 
# resource "aws_iam_group_membership" "assignment1" {
#   name = "sysadmin-membership"
 
#   users = [
#     aws_iam_user.Sysadmin1.name,
#     aws_iam_user.Sysadmin2.name
#   ]
 
#   group = aws_iam_group.SysAdmin.name
# }
 
# resource "aws_iam_group_policy_attachment" "admin" {
#   group      = aws_iam_group.SysAdmin.name
#   policy_arn = "arn:aws:iam::aws:policy/job-function/SystemAdministrator"
# }
 
# resource "aws_iam_group" "DBAdmin" {
#   name = "DBAdmin"
# }
 
# resource "aws_iam_user" "dbadmin1" {
#   name = "dbadmin1"
# }
 
# resource "aws_iam_user" "dbadmin2" {
#   name = "dbadmin2"
# }
 
# resource "aws_iam_group_membership" "assignment2" {
#   name = "dbadmin-membership"
 
#   users = [
#     aws_iam_user.dbadmin1.name,
#     aws_iam_user.dbadmin2.name
#   ]
 
#   group = aws_iam_group.DBAdmin.name
# }
 
# resource "aws_iam_group_policy_attachment" "database" {
#   group      = aws_iam_group.DBAdmin.name
#   policy_arn = "arn:aws:iam::aws:policy/job-function/DatabaseAdministrator"
# }
 
# resource "aws_iam_group" "Monitor" {
#   name = "Monitor"
# }
 
# resource "aws_iam_user" "monitoruser1" {
#   name = "monitoruser1"
# }
 
# resource "aws_iam_user" "monitoruser2" {
#   name = "monitoruser2"
# }
 
# resource "aws_iam_user" "monitoruser3" {
#   name = "monitoruser3"
# }
 
# resource "aws_iam_user" "monitoruser4" {
#   name = "monitoruser4"
# }
 
# resource "aws_iam_group_membership" "assignment3" {
#   name = "monitor-membership"
 
#   users = [
#     aws_iam_user.monitoruser1.name,
#     aws_iam_user.monitoruser2.name,
#     aws_iam_user.monitoruser3.name,
#     aws_iam_user.monitoruser4.name
#   ]
 
#   group = aws_iam_group.Monitor.name
# }
 
# resource "aws_iam_group_policy_attachment" "ec2" {
#   group      = aws_iam_group.Monitor.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
# }
 
# resource "aws_iam_group_policy_attachment" "s3" {
#   group      = aws_iam_group.Monitor.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
# }
 
# resource "aws_iam_group_policy_attachment" "RDS" {
#   group      = aws_iam_group.Monitor.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
# }

# resource "aws_iam_account_password_policy" "strict" {
#   minimum_password_length        = 8
#   max_password_age               = 90
#   password_reuse_prevention      = 3
#   require_lowercase_characters   = true
#   require_numbers                = true
#   require_uppercase_characters   = true
#   require_symbols                = true
#   allow_users_to_change_password = true
 
# }
 