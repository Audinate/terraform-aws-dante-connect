#
# Copyright 2023 Audinate Pty Ltd and/or its licensors
#
#
variable "subnet_id" {
  description = "The VPC Subnet ID the instances will be launched in"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID the instances will be created in"
  type        = string
}

variable "region" {
  description = "Region the instances will be created in"
  type        = string
}

variable "dvs_version" {
  description = "(Optional) The version of DVS to be installed"
  type        = string
  default     = null
}

variable "dgw_version" {
  description = "(Optional) The version of Dante Gateway to be installed"
  type        = string
  default     = null
}

variable "ddm_api_key" {
  description = "DDM API key"
  type        = string
}

variable "ddm_api_host" {
  description = "The DDM API URL"
  type        = string
}

variable "dante_domain" {
  description = "The domain to enroll the device in"
  type        = string
}
