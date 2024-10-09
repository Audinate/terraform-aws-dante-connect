#
# File : outputs.tf
# Created : July 2023
# Authors :
# Synopsis:
#
# Copyright 2023 Audinate Pty Ltd and/or its licensors
#
#
output "dgw_private_ip" {
  value       = module.dgw[0].ec2_instance_private_ip
  description = "Private IP of the Dante Gateway instance"
}
output "dgw_instance_name" {
  value       = module.dgw[0].ec2_instance_name
  description = "Name of Dante Gateway EC2 instance"
}