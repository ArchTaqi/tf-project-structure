resource "aws_lb" "main" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_group_ids
  subnets            = var.public_subnet_ids

  enable_deletion_protection = var.enable_deletion_protection

  access_logs {
    bucket  = aws_s3_bucket.lb_logs.bucket
    prefix  = var.alb_name
    enabled = true
  }

  tags = {
    Name        = var.alb_name
    Environment = var.environment
  }
}

resource "aws_alb_target_group" "main" {
  name        = "${var.alb_name}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = var.health_check_url
    port                = "traffic-port"
    healthy_threshold   = "3"
    unhealthy_threshold = "10"
    protocol            = "HTTP"
    timeout             = "3"
    interval            = "30"
    matcher             = "200"
  }

  depends_on = [
    aws_lb.main,
  ]

  tags = {
    Name        = "${var.alb_name}-tg"
    Environment = var.environment
  }
}

# Redirect to https listener
#resource "aws_alb_listener" "http" {
#  load_balancer_arn = aws_lb.main.id
#  port              = 80
#  protocol          = "HTTP"
#  depends_on        = [aws_alb_target_group.main]
#
#  default_action {
#    type = "redirect"
#
#    redirect {
#      port        = 443
#      protocol    = "HTTPS"
#      status_code = "HTTP_301"
#    }
#  }
#}

# Redirect traffic to target group
resource "aws_alb_listener" "https" {
  load_balancer_arn = aws_lb.main.id
  port              = 443
  protocol          = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn = var.alb_tls_cert_arn
  depends_on      = [aws_alb_target_group.main]

  default_action {
    target_group_arn = aws_alb_target_group.main.id
    type             = "forward"
  }
}

resource "aws_lb_listener_certificate" "https_additional_certs" {
  count           = length(var.additional_certs)
  listener_arn    = join("", aws_alb_listener.https.*.arn)
  certificate_arn = var.additional_certs[count.index]
}
