resource "aws_s3_bucket" "chess_storage" {
  bucket = "${var.app_name}-storage"

  tags = {
    Name        = "${var.app_name}-s3"
    Environment = var.environment
  }
}
