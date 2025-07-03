#
# File : outputs.tf
# Created : April 2023
# Authors :
# Synopsis:
#
# Copyright 2023-2025 Audinate Pty Ltd and/or its licensors
#
#
output "alb_dns_name" {
  value = aws_alb.alb.dns_name
}

output "alb_security_groups" {
  value = aws_alb.alb.security_groups
}