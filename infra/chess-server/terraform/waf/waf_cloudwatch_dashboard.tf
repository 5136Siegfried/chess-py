resource "aws_cloudwatch_dashboard" "chess_waf_dashboard" {
  dashboard_name = "ChessWAFDashboard"

  dashboard_body = <<DASHBOARD
{
  "widgets": [
    {
      "type": "metric",
      "x": 0,
      "y": 0,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          ["AWS/WAFV2", "BlockedRequests", "WebACL", "${aws_wafv2_web_acl.chess_waf.name}", "Region", "REGIONAL"]
        ],
        "title": "🚨 Requêtes Bloquées par le WAF",
        "view": "timeSeries",
        "stacked": false,
        "region": "us-east-1",
        "period": 300
      }
    },
    {
      "type": "metric",
      "x": 0,
      "y": 6,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          ["AWS/WAFV2", "AllowedRequests", "WebACL", "${aws_wafv2_web_acl.chess_waf.name}", "Region", "REGIONAL"]
        ],
        "title": "✅ Requêtes Autorisées",
        "view": "timeSeries",
        "stacked": false,
        "region": "us-east-1",
        "period": 300
      }
    },
    {
      "type": "log",
      "x": 12,
      "y": 0,
      "width": 12,
      "height": 12,
      "properties": {
        "query": "fields @timestamp, @message | sort @timestamp desc",
        "region": "us-east-1",
        "stacked": false,
        "title": "📜 Logs des attaques bloquées",
        "logGroupNames": ["/aws/waf/chess-waf-logs"]
      }
    }
  ]
}
DASHBOARD
}
