#
# File : outputs.tf
# Created : July 2023
# Authors :
# Synopsis:
#
# Copyright 2023-2025 Audinate Pty Ltd and/or its licensors
#
#
output "dvs_private_ip" {
  value       = module.dvs[0].ec2_instance_private_ip
  description = "Private IP of the Dante Virtual Soundcard instance"
}
output "dvs_instance_name" {
  value       = module.dvs[0].ec2_instance_name
  description = "Name of Dante Virtual Soundcard EC2 instance"
}