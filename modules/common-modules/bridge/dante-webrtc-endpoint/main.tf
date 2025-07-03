#
# File : main.tf
# Created : August 2024
# Authors :
# Synopsis:
#
# Copyright 2024-2025 Audinate Pty Ltd and/or its licensors
#
#
locals {
  instance_suffix             = random_id.random.hex
  webrtc_endpoint_setup_vars = {
    identifiers = var.product_identifiers
    installer_version = var.installer_version
    resource_url = var.resource_url
  }
  webrtc_endpoint_config_vars = {
    ddm_address            = var.ddm_address
    audio_settings         = var.audio_settings
    license_key            = var.license_key
    license_server         = var.license_server
    license_websocket_port = var.license_websocket_port
    stun_server_config     = var.stun_server_config
    turn_server_config     = var.turn_server_config != null ? join(" ", var.turn_server_config) : null
    web_admin_account      = var.web_admin_account
    identifiers            = var.product_identifiers
  }
  shared_dante_webrtc_endpoint_scripts_path  = "${path.module}/../../../shared-scripts/dante-webrtc-endpoint"
  dante_webrtc_endpoint_installation_script  = templatefile("${local.shared_dante_webrtc_endpoint_scripts_path}/dante-webrtc-setup.sh.tftpl", local.webrtc_endpoint_setup_vars)
  dante_webrtc_endpoint_configuration_script = templatefile("${local.shared_dante_webrtc_endpoint_scripts_path}/dante-webrtc-configuration.sh.tftpl", local.webrtc_endpoint_config_vars)
  create_security_group               = var.vpc_security_group_ids == null
  vpc_security_group_ids = local.create_security_group ? tolist([
    module.sg[0].bridge_sg_id
  ]) : var.vpc_security_group_ids
}

# Resources when creating the Dante-WebRTC endpoint from scratch
module "dante_webrtc_endpoint_base" {
  count  = 1
  source = "../../ec2/instance"

  ami_id = data.aws_ami.ubuntu.id

  associate_public_ip_address   = var.associate_public_ip_address
  vpc_security_group_ids        = local.vpc_security_group_ids
  subnet_id                     = var.subnet_id
  resolve_resource_name_to_ipv4 = false

  instance_type = var.instance_type
  key_name      = var.key_name
  volume_size   = var.volume_size
  user_data     = data.cloudinit_config.user_data.rendered
  environment   = var.environment
  instance_name = "ec2-${var.product_identifiers.product_abbreviation}-${var.environment}-${local.instance_suffix}"
}

module "dante_webrtc_endpoint_ddm_script" {
  count  = 1
  source = "../../../configuration"

  enroll_device     = (var.ddm_configuration != null)
  ip_address        = module.dante_webrtc_endpoint_base[count.index].ec2_instance_private_ip
  ddm_configuration = var.ddm_configuration

  depends_on = [module.dante_webrtc_endpoint_base]
  
}

resource "random_id" "random" {
  byte_length = 4

  keepers = {
    # Generate a new id each time we switch to a new AMI
    ami_id = data.aws_ami.ubuntu.id
  }
}

module "alb" {
  count  = var.create_alb ? 1 : 0
  source = "../alb"

  vpc_id                      = var.vpc_id
  component_name_abbreviation = var.product_identifiers.product_abbreviation
  environment                 = var.environment
  instance_suffix             = local.instance_suffix

  alb_public_subnets_ids = var.alb_public_subnets_ids
  alb_certificate_arn    = var.alb_certificate_arn
  bridge_instance_id     = module.dante_webrtc_endpoint_base[0].ec2_instance_id
}

module "sg" {
  count  = local.create_security_group ? 1 : 0
  source = "../security-group"

  vpc_id                      = var.vpc_id
  component_name_abbreviation = var.product_identifiers.product_abbreviation
  environment                 = var.environment
  instance_suffix             = local.instance_suffix
  alb_security_groups         = var.create_alb ? module.alb[0].alb_security_groups : []
}
