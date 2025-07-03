#
# File : outputs.tf
# Created : August 2024
# Authors :
# Synopsis:
#
# Copyright 2024-2025 Audinate Pty Ltd and/or its licensors
#

output "ec2_dante_webrtc_endpoint_instance_id" {
  value = module.dante_webrtc_endpoint_base[0].ec2_instance_id
}

output "alb_dns_name" {
  value = var.create_alb ? module.alb[0].alb_dns_name : "n/a"
}
