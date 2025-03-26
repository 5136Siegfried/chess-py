resource "aws_cognito_user" "admin" {
  user_pool_id = aws_cognito_user_pool.chess_users.id
  username     = "admin"
  temporary_password = "ChessAdmin2025!"

  attributes = {
    email          = "admin@chess.local"
    email_verified = "true"
  }

  force_alias_creation = false
  message_action       = "SUPPRESS"  # Pas d'e-mail envoyé
}

resource "aws_cognito_user_group" "admin_group" {
  user_pool_id = aws_cognito_user_pool.chess_users.id
  name         = "admins"
  description  = "Groupe admin OpenSearch"
  precedence   = 1
  role_arn     = aws_iam_role.cognito_opensearch_access.arn
}

resource "aws_cognito_user_in_group" "admin_member" {
  user_pool_id = aws_cognito_user_pool.chess_users.id
  username     = aws_cognito_user.admin.username
  group_name   = aws_cognito_user_group.admin_group.name
}
