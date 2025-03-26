resource "aws_cloudwatch_event_rule" "waf_attack_detected" {
  name        = "WAFAttackDetected"
  description = "Déclenché quand une attaque est détectée par le WAF"

  event_pattern = <<EOF
{
  "source": ["aws.waf"],
  "detail-type": ["AWS API Call via CloudTrail"],
  "detail": {
    "eventName": ["PutLoggingConfiguration"]
  }
}
EOF
}

resource "aws_cloudwatch_event_target" "ban_ip_lambda" {
  rule      = aws_cloudwatch_event_rule.waf_attack_detected.name
  target_id = "BanIPLambda"
  arn       = aws_lambda_function.ban_ip_lambda.arn
}
