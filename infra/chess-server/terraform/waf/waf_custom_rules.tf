resource "aws_wafv2_web_acl" "main" {
  name        = "chess-waf"
  description = "WAF pour le jeu d’échecs"
  scope       = "REGIONAL" # ou CLOUDFRONT

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    sampled_requests_enabled   = true
    metric_name                = "chess-waf"
  }
    rule {
    name     = "BlockBadUserAgents"
    priority = 10

    action {
      block {}
    }

    statement {
      byte_match_statement {
        field_to_match {
          single_header {
            name = "user-agent"
          }
        }

        positional_constraint = "CONTAINS"
        search_string         = "sqlmap"

        text_transformation {
          priority = 0
          type     = "LOWERCASE"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      sampled_requests_enabled   = true
      metric_name                = "bad-user-agents"
    }
  }
    rule {
    name     = "BlockLFIPaths"
    priority = 11

    action {
      block {}
    }

    statement {
      byte_match_statement {
        field_to_match {
          uri_path {}
        }

        positional_constraint = "CONTAINS"
        search_string         = "/etc/passwd"

        text_transformation {
          priority = 0
          type     = "URL_DECODE"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      sampled_requests_enabled   = true
      metric_name                = "lfi-block"
    }
  }

}

resource "aws_wafv2_ip_set" "manual_denylist" {
  name               = "ManualDenylist"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = ["1.2.3.4/32"]

}
