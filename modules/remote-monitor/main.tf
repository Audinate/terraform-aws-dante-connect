#
# File : main.tf
# Created : April 2023
# Authors :
# Synopsis:
#
# Copyright 2024-2025 Audinate Pty Ltd and/or its licensors
#
#

locals {
  license_key                 = var.license_key != null ? var.license_key : "5PV7P-E6UB4-HIX6R-UNCTC-6EES6"
}

# Resources when creating the Remote Monitor from scratch
module "remote_monitor" {
  count             = 1
  source            = "../common-modules/bridge/dante-webrtc-endpoint"
  instance_type     = var.instance_type
  vpc_security_group_ids = var.vpc_security_group_ids
  subnet_id         = var.subnet_id
  vpc_id            = var.vpc_id
  key_name = var.key_name
  ddm_address = var.ddm_address
  ddm_configuration = var.ddm_configuration
  audio_settings = var.audio_settings == null ? null : {
    rxChannels = var.audio_settings.rxChannels
    txChannels = 0
    rxLatencyUs = var.audio_settings.rxLatencyUs
    txLatencyUs = null
  }
  volume_size = var.volume_size
  environment       = var.environment
  installer_version = var.installer_version
  resource_url = var.resource_url
  associate_public_ip_address = var.associate_public_ip_address
  create_alb             = var.create_alb
  alb_public_subnets_ids = var.alb_public_subnets_ids
  alb_certificate_arn    = var.alb_certificate_arn
  stun_server_config = var.stun_server_config
  turn_server_config = var.turn_server_config
  license_key = local.license_key
  license_server = var.license_server
  license_websocket_port = var.license_websocket_port
  web_admin_account = var.web_admin_account
  product_identifiers = {
    service_name = "remote-monitor"
    product_name = "Remote Monitor"
    product_abbreviation = "rm"
  }
}
