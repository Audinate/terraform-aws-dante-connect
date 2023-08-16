#
# Copyright 2023 Audinate Pty Ltd and/or its licensors
#
#
variable "subnet_id_1" {
  description = "The VPC Subnet ID in region 1 the instances will be launched in"
  type        = string
}

variable "vpc_id_1" {
  description = "The VPC ID in region 1 the instances will be created in"
  type        = string
}

variable "region_1" {
  description = "The first region the instances will be created in"
  type        = string
}

variable "subnet_id_2" {
  description = "The VPC Subnet ID in region 2 the instances will be launched in"
  type        = string
}

variable "vpc_id_2" {
  description = "The VPC ID in region 2 the instances will be created in"
  type        = string
}

variable "region_2" {
  description = "The second region the instances will be created in"
  type        = string
}

variable "dvs_version" {
  description = "The version of DVS to be installed"
  type        = string
  default     = "4.4.0.3"
}

variable "dgw_version" {
  description = "The version of Dante Gateway to be installed"
  type        = string
  default     = "1.0.1.3"
}
