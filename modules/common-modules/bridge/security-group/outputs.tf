#
# File : outputs.tf
# Created : April 2023
# Authors :
# Synopsis:
#
# Copyright 2023-2025 Audinate Pty Ltd and/or its licensors
#
#
output "bridge_sg_id" {
  value = aws_security_group.bridge_sg.id
}