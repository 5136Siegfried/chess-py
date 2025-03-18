resource "aws_sns_topic" "waf_alerts" {
  name = "waf-security-alerts"
}

resource "aws_sns_topic_subscription" "waf_email_subscription" {
  topic_arn = aws_sns_topic.waf_alerts.arn
  protocol  = "email"
  endpoint  = "siegfried+security@5136.fr"
}
