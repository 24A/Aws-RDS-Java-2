# ---------------------------------------------------------
# Application Load Balancer
# ---------------------------------------------------------

resource "aws_lb" "app" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb.id
  ]

  subnets = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id
  ]

  idle_timeout               = 60
  drop_invalid_header_fields = true

  enable_deletion_protection = false

  tags = {
    Name = "${var.project_name}-alb"
    Tier = "LoadBalancer"
  }
}


# ---------------------------------------------------------
# Application Target Group
# ---------------------------------------------------------

resource "aws_lb_target_group" "app" {
  name = "${var.project_name}-tg"

  port        = 8080
  protocol    = "HTTP"
  target_type = "instance"

  vpc_id = aws_vpc.main.id

  deregistration_delay = 30

  health_check {
    enabled = true

    protocol = "HTTP"
    port     = "traffic-port"
    path     = "/LoginWebApp/"

    matcher = "200-399"

    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 5
  }

  stickiness {
    enabled         = true
    type            = "lb_cookie"
    cookie_duration = 3600
  }

  tags = {
    Name = "${var.project_name}-tg"
    Tier = "Application"
  }
}


# ---------------------------------------------------------
# HTTP Listener
# ---------------------------------------------------------

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn

  port     = 80
  protocol = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  tags = {
    Name = "${var.project_name}-http-listener"
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.app.arn

  port     = 443
  protocol = "HTTPS"

  certificate_arn = aws_acm_certificate.app.arn
  ssl_policy      = "ELBSecurityPolicy-TLS13-1-2-2021-06"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }

  tags = {
    Name = "${var.project_name}-https-listener"
  }
}