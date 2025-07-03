#
# File : main.tf
# Created : April 2023
# Authors :
# Synopsis:
#
# Copyright 2023-2025 Audinate Pty Ltd and/or its licensors
#
#
resource "aws_security_group" "bridge_sg" {
  name   = "Bridge ${var.environment} SG ${var.instance_suffix}"
  vpc_id = var.vpc_id

  tags = {
    Name        = "sg-${var.component_name_abbreviation}-${var.environment}-${var.instance_suffix}"
    Environment = var.environment
  }

  ingress {
    from_port   = 14336
    protocol    = "udp"
    to_port     = 14591
    cidr_blocks = ["10.0.0.0/8", "172.16.0.0/16", "192.168.0.0/16"]
  }

  ingress {
    from_port   = 319
    protocol    = "udp"
    to_port     = 320
    cidr_blocks = ["10.0.0.0/8", "172.16.0.0/16", "192.168.0.0/16"]
  }

  ingress {
    from_port   = 8800
    protocol    = "udp"
    to_port     = 8899
    cidr_blocks = ["10.0.0.0/8", "172.16.0.0/16", "192.168.0.0/16"]
  }

  ingress {
    from_port   = 38700
    protocol    = "udp"
    to_port     = 38900
    cidr_blocks = ["10.0.0.0/8", "172.16.0.0/16", "192.168.0.0/16"]
  }

  ingress {
    from_port   = 4440
    protocol    = "udp"
    to_port     = 4455
    cidr_blocks = ["10.0.0.0/8", "172.16.0.0/16", "192.168.0.0/16"]
  }

  ingress {
    from_port   = 3389
    protocol    = "tcp"
    to_port     = 3389
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    protocol    = "icmp"
    to_port     = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  dynamic "ingress" {
    for_each = var.alb_security_groups
    content {
      from_port = 80
      protocol  = "tcp"
      to_port   = 80
      # Only allow the security group on port 80
      security_groups = [ingress.value]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
