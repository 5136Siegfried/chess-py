# Création du Load Balancer
resource "aws_lb" "chess_alb" {
  name               = "chess-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.chess_sg.id]
  subnets           = aws_subnet.public[*].id

  enable_deletion_protection = false
}

# Target Group (où rediriger les requêtes)
resource "aws_lb_target_group" "chess_tg" {
  name     = "chess-target-group"
  port     = 5000
  protocol = "HTTP"
  vpc_id   = aws_vpc.chess_vpc.id
}

# Ajouter les instances EC2 dans le Load Balancer
resource "aws_lb_target_group_attachment" "chess_target" {
  count            = length(aws_instance.chess_server)
  target_group_arn = aws_lb_target_group.chess_tg.arn
  target_id        = aws_instance.chess_server[count.index].id
}

# Listener (redirige le trafic HTTP)
resource "aws_lb_listener" "chess_listener" {
  load_balancer_arn = aws_lb.chess_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.chess_tg.arn
  }
}
