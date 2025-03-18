# 📜 CloudWatch Log Group pour les logs applicatifs
resource "aws_cloudwatch_log_group" "chess_logs" {
  name              = "/chess-app/logs"
  retention_in_days = 7  # Garde les logs pendant 7 jours
}

# 📊 CloudWatch Metrics pour surveiller les instances EC2
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "High-CPU-Usage"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace          = "AWS/EC2"
  period             = 60
  statistic          = "Average"
  threshold          = 80
  alarm_description  = "Alerte si l'usage CPU dépasse 80% sur 2 minutes"
  actions_enabled    = true
  alarm_actions      = [aws_sns_topic.chess_alerts.arn]
  dimensions = {
    InstanceId = aws_instance.chess_server.id
  }
}

# 🔔 SNS Topic pour envoyer les alertes CloudWatch
resource "aws_sns_topic" "chess_alerts" {
  name = "chess-alerts"
}

# 🔔 Ajouter une alerte par e-mail
resource "aws_sns_topic_subscription" "email_alerts" {
  topic_arn = aws_sns_topic.chess_alerts.arn
  protocol  = "email"
  endpoint  = "siegfried@5136.fr"
}
