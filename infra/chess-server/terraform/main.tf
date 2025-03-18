resource "aws_instance" "chess_server" {
  ami           = var.instance_ami
  instance_type = var.instance_type

  tags = {
    Name = var.app_name
    Environment = var.environment
  }


  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install -y ansible"
    ]
  }

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i '${self.public_ip},' --private-key=~/.ssh/${var.key_name}.pem ansible/install_stockfish.yml"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/${var.key_name}.pem")
    host        = self.public_ip
  }
}

output "server_ip" {
  value = aws_instance.chess_server.public_ip
}

terraform {
  backend "s3" {
    bucket         = "chessgame-storage"
    key            = "terraform.tfstate"
    region         = "eu-west-3"
    encrypt        = true
  }
}

resource "aws_s3_bucket" "chess_data" {
  bucket = var.s3_bucket_name
}
