resource "aws_cognito_user_pool" "chess_users" {
  name = "chess-opensearch-users"
}

resource "aws_cognito_user_pool_client" "chess_client" {
  name         = "chess-opensearch-client"
  user_pool_id = aws_cognito_user_pool.chess_users.id
  generate_secret = false
}

resource "aws_cognito_identity_pool" "chess_identity" {
  identity_pool_name               = "chess-opensearch-identity"
  allow_unauthenticated_identities = false

  cognito_identity_providers {
    client_id     = aws_cognito_user_pool_client.chess_client.id
    provider_name = aws_cognito_user_pool.chess_users.endpoint
  }
}
