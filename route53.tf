resource "aws_route53_zone" "GoGreen_com" {
  name = "GoGreenCompany"
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.GoGreen_com.zone_id
  name    = "www.GoGreen.com"
  type    = "A"
  ttl     = 300
  records = [
    "1.2.3.4"
  ]
}