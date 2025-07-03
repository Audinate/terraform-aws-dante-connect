#
# File : main.tf
# Created : April 2023
# Authors :
# Synopsis:
#
# Copyright 2023-2025 Audinate Pty Ltd and/or its licensors
#
#
## Region Application Load Balancer

locals {
  resolved_alb_name = length("alb-${var.component_name_abbreviation}-${var.environment}-${var.instance_suffix}") > 32 ? "alb-${var.component_name_abbreviation}-${substr(var.environment, 0, 1)}-${var.instance_suffix}" : "alb-${var.component_name_abbreviation}-${var.environment}-${var.instance_suffix}"
  resolved_tg_name  = length("tg-${var.component_name_abbreviation}-${var.environment}-${var.instance_suffix}") > 32 ? "tg-${var.component_name_abbreviation}-${substr(var.environment, 0, 1)}-${var.instance_suffix}" : "tg-${var.component_name_abbreviation}-${var.environment}-${var.instance_suffix}"
}

resource "aws_security_group" "bridge_alb_sg" {
  name   = "Bridge ALB ${var.environment} SG ${var.instance_suffix}"
  vpc_id = var.vpc_id

  tags = {
    Name        = "sg-${var.component_name_abbreviation}-${var.environment}-${var.instance_suffix}"
    Environment = var.environment
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_alb_target_group" "target_group" {
  name = local.resolved_tg_name

  target_type      = "instance"
  protocol         = "HTTP"
  port             = 80
  protocol_version = "HTTP1"
  vpc_id           = var.vpc_id

  health_check {
    interval = 30
    // Just request the index.html
    path                = "/"
    port                = "traffic-port"
    enabled             = true
    timeout             = 5
    unhealthy_threshold = 2
    healthy_threshold   = 5
    protocol            = "HTTP"
  }

  tags = {
    Environment = var.environment
  }
}

resource "aws_lb_target_group_attachment" "ec2" {
  target_group_arn = aws_alb_target_group.target_group.arn
  target_id        = var.bridge_instance_id
}

resource "aws_alb" "alb" {
  name               = local.resolved_alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.bridge_alb_sg.id]
  ip_address_type    = "ipv4"
  subnets            = var.alb_public_subnets_ids

  tags = {
    Environment = var.environment
  }
}

resource "aws_alb_listener" "alb_listener_https_443" {
  load_balancer_arn = aws_alb.alb.arn
  protocol          = "HTTPS"
  port              = 443
  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.target_group.arn
  }
  certificate_arn = var.alb_certificate_arn
}

resource "aws_alb_listener" "alb_listener_http_80" {
  load_balancer_arn = aws_alb.alb.arn
  protocol          = "HTTP"
  port              = 80
  default_action {
    type = "redirect"
    redirect {
      status_code = "HTTP_301"
      protocol    = "HTTPS"
      port        = "443"
    }
  }
}
