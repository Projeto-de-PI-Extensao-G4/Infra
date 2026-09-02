# TARGET GROUP

resource "aws_lb_target_group" "webservers" {
  name     = "cris-tg-webservers"
  port     = 80
  protocol = "HTTP"

  vpc_id = aws_vpc.cris_vpc.id

  target_type = "instance"

  health_check {
    enabled             = true
    protocol            = "HTTP"
    port                = "80"
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }

  tags = {
    Name = "cris-tg-webservers"
  }
}

# Colocando as duas instancias no meu target group

resource "aws_lb_target_group_attachment" "webserver01" {
  target_group_arn = aws_lb_target_group.webservers.arn
  target_id        = aws_instance.webserver01.id
  port             = 80
}


resource "aws_lb_target_group_attachment" "webserver02" {
  target_group_arn = aws_lb_target_group.webservers.arn
  target_id        = aws_instance.webserver02.id
  port             = 80
}

# Criacao do Load Balancer

resource "aws_lb" "application" {
  name               = "cris-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.load_balancer.id
  ]

  subnets = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id
  ]

  tags = {
    Name = "cris-alb"
  }
}

# ALB pra encaminhar chamada 80 pro target group

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.application.arn

  port     = 80
  protocol = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webservers.arn
  }
}