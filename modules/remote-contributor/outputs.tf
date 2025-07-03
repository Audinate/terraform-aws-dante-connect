#
# File : outputs.tf
# Created : August 2024
# Authors :
# Synopsis:
#
# Copyright 2024-2025 Audinate Pty Ltd and/or its licensors
#

output "ec2_remote_contributor_instance_id" {
  value = module.remote_contributor[0].ec2_dante_webrtc_endpoint_instance_id
}

output "alb_dns_name" {
  value = module.remote_contributor[0].alb_dns_name
}
