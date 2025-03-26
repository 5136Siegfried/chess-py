resource "aws_opensearch_domain" "waf_logs" {
  domain_name           = "chess-waf-logs"
  engine_version        = "OpenSearch_2.11"
#  enforce_https         = true
  node_to_node_encryption { enabled = true }
#  encryption_at_rest     { enabled = true }
  cognito_options {
    enabled          = true
    identity_pool_id = aws_cognito_identity_pool.chess_identity.id
    role_arn         = aws_iam_role.cognito_opensearch_access.arn
    user_pool_id     = aws_cognito_user_pool.chess_users.id
  }


  cluster_config {
    instance_type = "t3.small.search"
    instance_count = 1
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 10
    volume_type = "gp3"
  }

  access_policies = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { AWS = "*" } # à restreindre par IP ou rôle
        Action    = "es:*"
        Resource  = "*"
      }
    ]
  })

  tags = {
    Name = "ChessWAFLogs"
    Environment = var.environment
  }
}
