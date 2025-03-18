resource "aws_acm_certificate" "chess_ssl" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  tags = {
    Name = "ChessApp-SSL"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "ssl_validation" {
  for_each = {
    for dvo in aws_acm_certificate.chess_ssl.domain_validation_options :
    dvo.domain_name => {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  }

  zone_id = var.route53_zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "chess_ssl_validation" {
  certificate_arn         = aws_acm_certificate.chess_ssl.arn
  validation_record_fqdns = [for record in aws_route53_record.ssl_validation : record.fqdn]
}
