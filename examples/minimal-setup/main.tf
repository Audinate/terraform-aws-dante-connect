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
  channel_count     = 256
}

module "dvs_64" {
  count             = 1
  source            = "../../modules/virtual-soundcard"
  environment       = local.environment
  subnet_id         = var.subnet_id
  vpc_id            = var.vpc_id
  installer_version = var.dvs_version
  channel_count     = 64
}

module "dgw" {
  count             = 1
  source            = "../../modules/gateway"
  environment       = local.environment
  subnet_id         = var.subnet_id
  vpc_id            = var.vpc_id
  installer_version = var.dgw_version
}
