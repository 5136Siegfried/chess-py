provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "chess_server" {
  ami           = var.instance_ami
  instance_type = var.instance_type

  tags = {
    Name = var.app_name
    Environment = var.environment
  }
}

output "server_ip" {
  value = aws_instance.chess_server.public_ip
}
