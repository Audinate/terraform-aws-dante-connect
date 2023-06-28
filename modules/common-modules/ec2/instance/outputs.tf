#
# File : outputs.tf
# Created : April 2023
# Authors :
# Synopsis:
#
# Copyright 2023 Audinate Pty Ltd and/or its licensors
#
#
output "ec2_instance_id" {
  value = var.use_eip ? aws_instance.ec2_eip[0].id : aws_instance.ec2[0].id
}
output "ec2_instance_private_ip" {
  value = var.use_eip ? aws_instance.ec2_eip[0].private_ip : aws_instance.ec2[0].private_ip
}
output "ec2_instance_name" {
  value = var.use_eip ? aws_instance.ec2_eip[0].tags.Name : aws_instance.ec2[0].tags.Name
}
output "ec2_private_dns_name" {
  value = var.use_eip ? aws_instance.ec2_eip[0].private_dns : aws_instance.ec2[0].private_dns
}