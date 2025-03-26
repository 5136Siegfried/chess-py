resource "aws_lb" "chess_alb" {
  name               = "chess-app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.chess_alb_sg.id]
  subnets           = aws_subnet.public[*].id
}


resource "aws_lb_target_group" "chess_app_tg" {
  name     = "chess-app-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

# Ajouter les instances EC2 dans le Load Balancer
resource "aws_lb_target_group_attachment" "chess_target" {
  count            = length(aws_instance.chess_server)
  target_group_arn = aws_lb_target_group.chess_tg.arn
  target_id        = aws_instance.chess_server[count.index].id
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.chess_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.chess_ssl.arn

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.chess_app_tg.arn
  }
}

resource "aws_wafv2_web_acl_association" "alb_waf_attach" {
  resource_arn = aws_lb.main.arn
  web_acl_arn  = aws_wafv2_web_acl.main.arn
}
