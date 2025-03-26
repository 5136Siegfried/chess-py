resource "aws_s3_bucket" "waf_logs" {
  bucket = "chess-waf-logs-${var.environment}"
  force_destroy = true

  tags = {
    Name        = "WAF Logs Bucket"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "waf_logs_encryption" {
  bucket = aws_s3_bucket.waf_logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "waf_logs_block" {
  bucket                  = aws_s3_bucket.waf_logs.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_wafv2_logging_configuration" "waf_logs" {
  log_destination_configs = [aws_s3_bucket.waf_logs.arn]
  resource_arn            = aws_wafv2_web_acl.main.arn

  logging_filter {
    default_behavior = "KEEP"
  }

  redacted_fields {
    single_header {
      name = "Authorization"
    }
  }
}

output "waf_logs_bucket" {
  value = aws_s3_bucket.waf_logs.bucket
}
