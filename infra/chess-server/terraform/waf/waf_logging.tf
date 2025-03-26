resource "aws_cloudwatch_log_group" "waf_logs" {
  name              = "/aws/waf/chess-waf-logs"
  retention_in_days = 30
}

resource "aws_wafv2_web_acl_logging_configuration" "waf_logging" {
  log_destination_configs = [aws_kinesis_firehose_delivery_stream.waf_to_opensearch.arn]
  resource_arn           = aws_wafv2_web_acl.chess_waf.arn
}
