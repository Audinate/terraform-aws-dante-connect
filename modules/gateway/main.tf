#
# File : main.tf
# Created : April 2023
# Authors :
# Synopsis:
#
# Copyright 2023-2025 Audinate Pty Ltd and/or its licensors
#
#
locals {
  component_name_abbreviation = "dgw"
  license_keys = {
    "64"  = "VOHCA-43JSH-SQOW7-LQPDP-QKOOV"
    "256" = "BXS6K-R7UIL-T3UV5-XAJBZ-6TE6L"
  }
  license_counts         = [for count in keys(local.license_keys) : tonumber(count)]
  has_channel_count      = var.audio_settings == null ? false : var.audio_settings.txChannels != null && var.audio_settings.rxChannels != null
  channel_count          = local.has_channel_count ? max(var.audio_settings.txChannels, var.audio_settings.rxChannels) : min(local.license_counts...)
  licensed_channel_count = (var.licensed_channel_count != null) ? var.licensed_channel_count : min([for count in local.license_counts : count if count >= local.channel_count]...)
  license_key            = (var.license_key != null) ? var.license_key : local.license_keys[local.licensed_channel_count]

  dep_setup_vars = {
    ddm_address            = var.ddm_address
    audio_settings         = var.audio_settings
    license_key            = local.license_key
    license_server         = var.license_server
    license_websocket_port = var.license_websocket_port
    licensed_channel_count = local.licensed_channel_count
  }
  shared_dgw_scripts_path  = "${path.module}/../shared-scripts/dgw"
  dgw_installation_script  = file("${local.shared_dgw_scripts_path}/dgw-setup.sh")
  dgw_configuration_script = templatefile("${local.shared_dgw_scripts_path}/dgw-configuration.sh.tftpl", local.dep_setup_vars)
  vpc_security_group_ids   = (var.vpc_security_group_ids != null) ? var.vpc_security_group_ids : tolist([aws_security_group.dgw_sg[0].id])
}

# Resources when creating the Dante Gateway from scratch
module "dgw" {
  count  = 1
  source = "../common-modules/ec2/instance"

  ami_id = data.aws_ami.ubuntu.id

  associate_public_ip_address   = var.associate_public_ip_address
  vpc_security_group_ids        = local.vpc_security_group_ids
  subnet_id                     = var.subnet_id
  resolve_resource_name_to_ipv4 = false

  instance_type = var.instance_type
  key_name      = var.key_name
  volume_size   = var.volume_size

  user_data = data.cloudinit_config.user_data.rendered

  environment   = var.environment
  instance_name = "ec2-${local.component_name_abbreviation}-${var.environment}-${random_id.random.hex}"
}

module "dgw_ddm_script" {
  count  = 1
  source = "../configuration"

  enroll_device     = (var.ddm_configuration != null)
  ip_address        = module.dgw[count.index].ec2_instance_private_ip
  ddm_configuration = var.ddm_configuration

  depends_on = [module.dgw]
}

resource "random_id" "random" {
  byte_length = 4

  keepers = {
    # Generate a new id each time we switch to a new AMI
    ami_id = data.aws_ami.ubuntu.id
  }
}

# When no security group is provided, create one with the default settings.
resource "aws_security_group" "dgw_sg" {
  count  = (var.vpc_security_group_ids == null) ? 1 : 0
  name   = "Dante Gateway ${var.environment} SG ${random_id.random.hex}"
  vpc_id = var.vpc_id

  tags = {
    Name        = "sg-dgw-${var.environment}-${random_id.random.hex}"
    Environment = var.environment
  }

  ingress {
    from_port   = 319
    protocol    = "udp"
    to_port     = 320
    cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
  }

  ingress {
    from_port   = 14336
    protocol    = "udp"
    to_port     = 14591
    cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
  }

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8700
    protocol    = "udp"
    to_port     = 8899
    cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
  }

  ingress {
    from_port   = 4440
    protocol    = "udp"
    to_port     = 4455
    cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
  }

  ingress {
    from_port   = 38700
    protocol    = "udp"
    to_port     = 38900
    cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
  }

  ingress {
    from_port   = -1
    protocol    = "icmp"
    to_port     = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

