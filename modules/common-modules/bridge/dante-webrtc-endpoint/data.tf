#version
# File : data.tf
# Created : August 2024
# Authors :
# Synopsis:
#
# Copyright 2024 Audinate Pty Ltd and/or its licensors
#
#
# Retrieve the most recent AMI which matches the given filters
# Retrieved AMI is used to create instances of the Remote Monitor/Contributor, thus it must meet their system requirements
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
    filename     = "dante-webrtc-cloud-init.yaml"
    content_type = "text/cloud-config"

    content = templatefile("${local.shared_dante_webrtc_endpoint_scripts_path}/dante-webrtc-cloud-init.yaml.tftpl", {
      dante_webrtc_endpoint_installation = {
        script  = local.dante_webrtc_endpoint_installation_script
        version = var.installer_version
        url     = var.resource_url
      }
      dante_webrtc_endpoint_configuration_script = local.dante_webrtc_endpoint_configuration_script
    })
  }
}
