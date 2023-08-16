#
# Copyright 2023 Audinate Pty Ltd and/or its licensors
#
#
locals {
  environment = "test"
}

# Region 1
provider "aws" {
  region = var.region_1
  alias  = "provider_1"
}

module "dvs_256_region_1" {
  count       = 1
  source      = "../../modules/virtual-soundcard"
  environment = local.environment
  subnet_id   = var.subnet_id_1
  vpc_id      = var.vpc_id_1
  dvs_version = var.dvs_version

  channel_count = 256
  latency       = 10

  providers = {
    aws = aws.provider_1
  }
}

module "dvs_64_region_1" {
  count       = 1
  source      = "../../modules/virtual-soundcard"
  environment = local.environment
  subnet_id   = var.subnet_id_1
  vpc_id      = var.vpc_id_1
  dvs_version = var.dvs_version

  channel_count = 64
  latency       = 10

  providers = {
    aws = aws.provider_1
  }
}

module "dgw_region_1" {
  count       = 1
  source      = "../../modules/gateway"
  environment = local.environment
  subnet_id   = var.subnet_id_1
  vpc_id      = var.vpc_id_1
  dgw_version = var.dgw_version

  audio_settings = {
    txChannels  = 64
    rxChannels  = 64
    txLatencyUs = 10000
    rxLatencyUs = 100000
  }

  providers = {
    aws = aws.provider_1
  }
}

# Region 2
provider "aws" {
  region = var.region_2
  alias  = "provider_2"
}

module "dvs_256_region_2" {
  count       = 1
  source      = "../../modules/virtual-soundcard"
  environment = local.environment
  subnet_id   = var.subnet_id_2
  vpc_id      = var.vpc_id_2
  dvs_version = var.dvs_version

  channel_count = 256
  latency       = 20

  providers = {
    aws = aws.provider_2
  }
}

module "dvs_64_region_2" {
  count       = 1
  source      = "../../modules/virtual-soundcard"
  environment = local.environment
  subnet_id   = var.subnet_id_2
  vpc_id      = var.vpc_id_2
  dvs_version = var.dvs_version

  channel_count = 64
  latency       = 20

  providers = {
    aws = aws.provider_2
  }
}

module "dgw_region_2" {
  count       = 1
  source      = "../../modules/gateway"
  environment = local.environment
  subnet_id   = var.subnet_id_2
  vpc_id      = var.vpc_id_2
  dgw_version = var.dgw_version

  audio_settings = {
    txChannels  = 256
    rxChannels  = 256
    txLatencyUs = 10000
    rxLatencyUs = 100000
  }

  providers = {
    aws = aws.provider_2
  }
}
