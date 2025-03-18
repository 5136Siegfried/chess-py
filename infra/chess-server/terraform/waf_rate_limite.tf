resource "aws_wafv2_web_acl_rule" "rate_limit_ip" {
  name     = "rate-limit-ip"
  priority = 1

  action {
    block {}
  }

  statement {
    rate_based_statement {
      limit              = 100  # 100 requêtes par minute max
      aggregate_key_type = "IP"
    }
  }

  visibility_config {
    sampled_requests_enabled    = true
    cloudwatch_metrics_enabled  = true
    metric_name                 = "rate-limit-ip"
  }
}

resource "aws_wafv2_web_acl_rule" "rate_limit_user_agent" {
  name     = "rate-limit-user-agent"
  priority = 2

  action {
    block {}
  }

  statement {
    rate_based_statement {
      limit              = 200  # 200 requêtes par minute max
      aggregate_key_type = "FORWARDED_IP"

      scope_down_statement {
        byte_match_statement {
          field_to_match {
            single_header {
              name = "User-Agent"
            }
          }
          positional_constraint = "CONTAINS"
          search_string         = "Scrapy"  # Exemple : bloquer les bots Scrapy
          text_transformation {
            priority = 0
            type     = "LOWERCASE"
          }
        }
      }
    }
  }

  visibility_config {
    sampled_requests_enabled    = true
    cloudwatch_metrics_enabled  = true
    metric_name                 = "rate-limit-user-agent"
  }
}
