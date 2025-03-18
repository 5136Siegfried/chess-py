resource "aws_cloudwatch_metric_alarm" "waf_attack_alert" {
  alarm_name          = "WAF-High-Blocked-Requests"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "BlockedRequests"
  namespace          = "AWS/WAFV2"
  period             = 300
  statistic         = "Sum"
  threshold         = 50
  alarm_description  = "🚨 Plus de 50 requêtes bloquées par AWS WAF en 5 minutes !"
  actions_enabled    = true
  alarm_actions      = [aws_sns_topic.waf_alerts.arn]

  dimensions = {
    WebACL = aws_wafv2_web_acl.chess_waf.name
    Region = "REGIONAL"
  }
}
