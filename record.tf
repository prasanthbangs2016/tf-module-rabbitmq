resource "aws_route53_record" "rabbitmq" {
  zone_id = data.aws_route53_zone.private.id
  name    = "rabbimq-${var.env}.roboshop.internal"
  type    ="A"
  ttl     = 30
  records = [aws_spot_instance_request.rabbitmq.private_ip]
}