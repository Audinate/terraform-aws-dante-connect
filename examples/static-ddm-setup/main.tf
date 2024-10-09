#
# Copyright 2023 Audinate Pty Ltd and/or its licensors
#
#
locals {
  environment = "test"
}

module "dvs_256" {
  count             = 1
  source            = "../../modules/virtual-soundcard"
  environment       = local.environment
  subnet_id         = var.subnet_id
  vpc_id            = var.vpc_id
  installer_version = var.dvs_version

  channel_count = 256
  latency       = 20

  ddm_address = {
    hostname = var.ddm_hostname
    ip       = var.ddm_ip
    port     = var.ddm_port
  }
}

module "dvs_64" {
  count             = 1
  source            = "../../modules/virtual-soundcard"
  environment       = local.environment
  subnet_id         = var.subnet_id
  vpc_id            = var.vpc_id
  installer_version = var.dvs_version

  channel_count = 64
  latency       = 10

  ddm_address = {
    hostname = var.ddm_hostname
    ip       = var.ddm_ip
    port     = var.ddm_port
  }
}

module "dgw" {
  count             = 1
  source            = "../../modules/gateway"
  environment       = local.environment
  subnet_id         = var.subnet_id
  vpc_id            = var.vpc_id
  installer_version = var.dgw_version

  audio_settings = {
    txChannels  = 64
    rxChannels  = 64
    txLatencyUs = 10000
    rxLatencyUs = 100000
  }

  ddm_address = {
    hostname = var.ddm_hostname
    ip       = var.ddm_ip
    port     = var.ddm_port
  }
}
