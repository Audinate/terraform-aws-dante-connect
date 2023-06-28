#
# File : main.tf
# Created : April 2023
# Authors :
# Synopsis:
#
# Copyright 2023 Audinate Pty Ltd and/or its licensors
#
#

locals {
  component_name_abbreviation = "dvs"
  instance_type               = var.instance_type == null && var.channel_count <= 64 ? "m5.large" : "m5.2xlarge"
  vpc_security_group_ids = (var.vpc_security_group_ids != null) ? var.vpc_security_group_ids : tolist([
    aws_security_group.dvs_sg[0].id
  ])
  shared_dvs_scripts_path = "${path.module}/../shared-scripts/dvs"
  dvs_installation_script = file("${local.shared_dvs_scripts_path}/dvs-installation.ps1")
  dvs_configuration_script = templatefile("${local.shared_dvs_scripts_path}/dvs-configuration.ps1.tftpl", {
    dvs_license           = var.license_key,
    ddm_address           = var.ddm_address
    audio_driver          = var.audio_driver,
    channel_count         = var.channel_count,
    latency               = var.latency,
    licenseServerHostname = var.licenseServerConfig != null ? var.licenseServerConfig.licenseServerHostname : null
    licenseServerApiKey   = var.licenseServerConfig != null ? var.licenseServerConfig.licenseServerApiKey : null
  })
  reaper_installation_script = templatefile("${local.shared_dvs_scripts_path}/dvs-install-reaper.ps1.tftpl", {
    install_reaper = var.install_reaper
  })
}

# Resources when creating the Dante Virtual Soundcard from scratch
module "dvs" {
  count  = 1
  source = "../common-modules/ec2/instance"

  ami_id = data.aws_ami.windows.id

  associate_public_ip_address   = var.associate_public_ip_address
  vpc_security_group_ids        = local.vpc_security_group_ids
  subnet_id                     = var.subnet_id
  resolve_resource_name_to_ipv4 = false

  instance_type = local.instance_type
  key_name      = var.key_name
  volume_size   = var.volume_size

  user_data = <<-EOT
    <powershell>
    $Env:DVS_VERSION = "${var.dvs_version}"
    $Env:DVS_RESOURCE_URL = "${var.dvs_resource_url}"
    ${local.dvs_installation_script}
    ${local.dvs_configuration_script}
    ${local.reaper_installation_script}
    </powershell>
  EOT

  environment   = var.environment
  instance_name = "ec2-${local.component_name_abbreviation}-${var.environment}-${random_id.random.hex}"
}

module "dvs_ddm_script" {
  count  = 1
  source = "../configuration"

  enroll_device     = (var.ddm_configuration != null)
  ip_address        = module.dvs[count.index].ec2_instance_private_ip
  ddm_configuration = var.ddm_configuration

  depends_on = [module.dvs]
}

resource "random_id" "random" {
  byte_length = 4

  keepers = {
    # Generate a new id each time we switch to a new AMI
    ami_id = data.aws_ami.windows.id
  }
}

# When no security group is provided, create one with the default settings.
resource "aws_security_group" "dvs_sg" {
  count  = (var.vpc_security_group_ids == null) ? 1 : 0
  name   = "Dante Virtual Soundcard ${var.environment} SG ${random_id.random.hex}"
  vpc_id = var.vpc_id

  tags = {
    Name        = "sg-dvs-${var.environment}-${random_id.random.hex}"
    Environment = var.environment
  }

  ingress {
    from_port   = 14336
    protocol    = "udp"
    to_port     = 14591
    cidr_blocks = ["10.0.0.0/8", "172.16.0.0/16", "192.168.0.0/16"]
  }

  ingress {
    from_port   = 319
    protocol    = "tcp"
    to_port     = 320
    cidr_blocks = ["10.0.0.0/8", "172.16.0.0/16", "192.168.0.0/16"]
  }

  ingress {
    from_port   = 8700
    protocol    = "udp"
    to_port     = 8899
    cidr_blocks = ["10.0.0.0/8", "172.16.0.0/16", "192.168.0.0/16"]
  }

  ingress {
    from_port   = 38700
    protocol    = "udp"
    to_port     = 38900
    cidr_blocks = ["10.0.0.0/8", "172.16.0.0/16", "192.168.0.0/16"]
  }

  ingress {
    from_port   = 4440
    protocol    = "udp"
    to_port     = 4455
    cidr_blocks = ["10.0.0.0/8", "172.16.0.0/16", "192.168.0.0/16"]
  }

  ingress {
    from_port   = 3389
    protocol    = "tcp"
    to_port     = 3389
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    protocol    = "icmp"
    to_port     = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
