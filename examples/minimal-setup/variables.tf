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
  description = "The version of DVS to be installed"
  type        = string
  default     = "4.4.0.3"
}

variable "dgw_version" {
  description = "The version of Dante Gateway to be installed"
  type        = string
  default     = "1.0.0.2"
}

variable "dvs_256_license_key" {
  description = "The DVS 256-channel license provided by Audinate"
  type        = string
  sensitive   = true
  default     = "NISBH-ZQG2O-KAKHZ-XHYWZ-IA32H"
}

variable "dvs_64_license_key" {
  description = "The DVS 64-channel license provided by Audinate"
  type        = string
  sensitive   = true
  default     = "6PDZW-HAT54-QMS7B-4SEB7-SOOYS"
}
