resource "aws_iam_role" "firehose_role" {
  name = "chess-firehose-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "firehose.amazonaws.com"
      }
    }]
  })
}
#TODO invocation waf_log
resource "aws_kinesis_firehose_delivery_stream" "waf_to_opensearch" {
  name        = "chess-waf-firehose"
  destination = "opensearch"

  opensearch_configuration {
    domain_arn = aws_opensearch_domain.waf_logs.arn
    index_name = "waf-logs"
    role_arn   = aws_iam_role.firehose_role.arn
  }

  s3_configuration {
    role_arn           = aws_iam_role.firehose_role.arn
    bucket_arn         = aws_s3_bucket.waf_logs.arn
    buffering_interval = 60
  }
}
