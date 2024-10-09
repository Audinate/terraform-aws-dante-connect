#
# File : data.tf
# Created : April 2023
# Authors :
# Synopsis:
#
# Copyright 2023 Audinate Pty Ltd and/or its licensors
#
#
# Retrieve the most recent AMI which matches the given filters
# Retrieved AMI is used to create instances of the DGW, thus it must meet DGW's system requirements
data "aws_ami" "ubuntu" {

  most_recent = true

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }

  owners = ["amazon"]
}

data "cloudinit_config" "user_data" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "dgw-cloud-init.yaml"
    content_type = "text/cloud-config"

    content = templatefile("${local.shared_dgw_scripts_path}/dgw-cloud-init.yaml.tftpl", {
      dgw_installation = {
        script  = local.dgw_installation_script
        version = var.dgw_version != null ? var.dgw_version : var.installer_version
        url     = var.resource_url
      }
      dgw_configuration_script = local.dgw_configuration_script
    })
  }
}
