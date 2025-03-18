resource "aws_wafv2_ip_set" "denylist" {
  name               = "chess-denylist"
  description        = "denylist des IPs malveillantes"
  scope             = "REGIONAL"
  ip_address_version = "IPV4"

  addresses = [
    "192.168.1.100/32", # Exemple d’IP bannie
    "203.0.113.50/32"
  ]
}

resource "aws_wafv2_web_acl_rule" "denylist_rule" {
  name     = "denylist-rule"
  priority = 3

  action {
    block {}
  }

  statement {
    ip_set_reference_statement {
      arn = aws_wafv2_ip_set.denylist.arn
    }
  }

  visibility_config {
    sampled_requests_enabled    = true
    cloudwatch_metrics_enabled  = true
    metric_name                 = "denylist-rule"
  }
}
