security_groups = {
  "server_sg" : {
    description = "Security group for app server"
    ingress_rules = [
      {
        description = "ingress rule for http"
        priority    = 200
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        description = "my_ssh"
        priority    = 202
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        description = "ingress rule for http"
        priority    = 204
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
    egress_rules = [
      {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  }
 }
# iam_user = {
#   sysadmin1 = {
#     name = "sysadmin1"
#     tags = { creator = "sysadmin1"
#   } },
#   sysadmin2 = {
#     name = "sysadmin2"
#     tags = { creator = "sysadmin2"
#   } }
#   monitor1 = {
#     name = "monitor1"
#     tags = { creator = "monitor1"
#   } }
#   monitor2 = {
#     name = "monitor2"
#     tags = { creator = "monitor2"
#   } }
#   monitor3 = {
#     name = "monitor3"
#     tags = { creator = "monitor3"
#   } }
#   monitor4 = {
#     name = "monitor4"
#     tags = { creator = "monitor4"
#   } }
#   dbadmin1 = {
#     name = "dbadmin1"
#     tags = { creator = "dbadmin1"
#   } }
#   dbadmin2 = {
#     name = "dbadmin2"
#     tags = { creator = "dbadmin2"
#   } }
# }