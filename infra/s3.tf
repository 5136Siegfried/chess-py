resource "aws_s3_bucket" "chess_storage" {
  bucket = "${var.app_name}-storage"

  tags = {
    Name        = "${var.app_name}-s3"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_object" "chess_games_folder" {
  bucket = aws_s3_bucket.chess_storage.id
  key    = "games/"
}
