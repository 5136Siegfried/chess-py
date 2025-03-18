variable "environment" { type = string }
variable "key_name" { type = string }
variable "app_name" { type = string }

variable "aws_region" {
  description = "Région AWS"
  type        = string
  default     = "eu-west-1"
}

variable "instance_type" {
  description = "Type d'instance EC2"
  type        = string
  default     = "t3.micro"
}
variable "instance_ami" {
  description = "AMI EC2 ( ubuntu)"
  type        = string
  default     = "ami-0abcdef1234567890"
}

variable "repo_url" {
  description = "URL du dépôt Git"
  type        = string
  default     = "https://github.com/5136Siegfried/chess-py.git"
}

variable "s3_bucket_name" {
  description = "Nom du bucket S3"
  default     = "chess-game-bucket"
}