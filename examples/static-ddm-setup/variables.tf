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

variable "ddm_hostname" {
  description = "(Optional) The hostname of the DDM"
  type        = string
  default     = null
  nullable    = true
}

variable "ddm_ip" {
  description = "The private IPv4 of the DDM"
  type        = string
}

variable "ddm_port" {
  description = "(Optional) The port of the DDM used for device communication"
  type        = string
  default     = null
  nullable    = true
}
