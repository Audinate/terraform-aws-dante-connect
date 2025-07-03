#
# File : main.tf
# Created : April 2023
# Authors :
# Synopsis:
#
# Copyright 2023-2025 Audinate Pty Ltd and/or its licensors
#
#
resource "aws_instance" "ec2" {
  count                       = var.use_eip ? 0 : 1
  associate_public_ip_address = var.associate_public_ip_address
  ami                         = var.ami_id
  instance_type               = var.instance_type
  vpc_security_group_ids      = var.vpc_security_group_ids
  subnet_id                   = var.subnet_id
  iam_instance_profile        = var.iam_instance_profile
  source_dest_check           = var.source_dest_check
  dynamic "private_dns_name_options" {
    for_each = var.resolve_resource_name_to_ipv4 ? [1] : []
    content {
      enable_resource_name_dns_a_record = true
      hostname_type                     = "resource-name"
    }
  }
  key_name = var.key_name
  root_block_device {
    encrypted   = true
    volume_size = var.volume_size
  }
  user_data = var.user_data
  # If the startup script or startup script parameters change, we will need to
  # recreate the instance, as they are designed to only run on startup
  user_data_replace_on_change = true
  tags = {
    Name        = var.instance_name
    Environment = var.environment
  }
  # Ignore base AMI changes. We want to determine when to create
  # new instances. Suddenly creating a new instance might be very disturbing
  lifecycle {
    ignore_changes = [
      ami,
    ]
  }
}


# EC2 with elastic IP address
resource "aws_instance" "ec2_eip" {
  count                = var.use_eip ? 1 : 0
  ami                  = var.ami_id
  instance_type        = var.instance_type
  iam_instance_profile = var.iam_instance_profile

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.eni[0].id
  }
  dynamic "private_dns_name_options" {
    for_each = var.resolve_resource_name_to_ipv4 ? [1] : []
    content {
      enable_resource_name_dns_a_record = true
      hostname_type                     = "resource-name"
    }
  }
  key_name = var.key_name
  root_block_device {
    encrypted   = true
    volume_size = var.volume_size
  }
  user_data = var.user_data
  # If the startup script or startup script parameters change, we will need to
  # recreate the instance, as they are designed to only run on startup
  user_data_replace_on_change = true
  tags = {
    Name        = var.instance_name
    Environment = var.environment
  }
  # Ignore base AMI changes. We want to determine when to create
  # new instances. Suddenly creating a new instance might be very disturbing
  lifecycle {
    ignore_changes = [
      ami,
    ]
  }
}

resource "aws_network_interface" "eni" {
  count             = var.use_eip ? 1 : 0
  subnet_id         = var.subnet_id
  security_groups   = var.vpc_security_group_ids
  source_dest_check = var.source_dest_check
}

resource "aws_eip" "eip_for_eni" {
  count             = var.use_eip && var.associate_public_ip_address != false ? 1 : 0
  vpc               = true
  network_interface = aws_network_interface.eni[0].id
  tags = {
    Name = var.instance_name
  }
}




