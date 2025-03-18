# 🔒 Rôle IAM pour permettre à l'EC2 d'envoyer des logs à CloudWatch
resource "aws_iam_role" "chess_cloudwatch_role" {
  name = "chess-cloudwatch-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

# 🔑 Attacher la politique CloudWatch Logs
resource "aws_iam_role_policy_attachment" "chess_cloudwatch_attach" {
  role       = aws_iam_role.chess_cloudwatch_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# 🔗 Associer le rôle à l'instance EC2
resource "aws_iam_instance_profile" "chess_instance_profile" {
  name = "chess-instance-profile"
  role = aws_iam_role.chess_cloudwatch_role.name
}

resource "aws_instance" "chess_server" {
  ami                  = var.instance_ami
  instance_type        = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.chess_instance_profile.name
  user_data            = file("${path.module}/ec2-userdata.sh")
  tags = {
    Name = "ChessServer"
  }
}
