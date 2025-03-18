resource "aws_wafv2_ip_set" "malicious_ips" {
  name               = "MaliciousIPs"
  scope             = "REGIONAL"
  ip_address_version = "IPV4"

  addresses = []  # Sera mis à jour dynamiquement

  tags = {
    Name = "Malicious IPs"
  }
}

resource "aws_wafv2_rule_group" "denylist_rule" {
  name     = "MaliciousListRule"
  scope    = "REGIONAL"
  capacity = 100

  rule {
    name     = "BlockMaliciousIPs"
    priority = 1

    action {
      block {}
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.malicious_ips.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "BlockMaliciousIPs"
      sampled_requests_enabled   = true
    }
  }
}
