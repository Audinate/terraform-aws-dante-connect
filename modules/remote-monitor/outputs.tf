#
# File : outputs.tf
# Created : April 2023
# Authors :
# Synopsis:
#
# Copyright 2024 Audinate Pty Ltd and/or its licensors
#

output "ec2_remote_monitor_instance_id" {
  value = module.remote_monitor[0].ec2_dante_webrtc_endpoint_instance_id
}

output "alb_dns_name" {
  value = module.remote_monitor[0].alb_dns_name
}
