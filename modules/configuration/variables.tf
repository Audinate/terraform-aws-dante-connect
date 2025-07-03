#
# File : variables.tf
# Created : April 2023
# Authors :
# Synopsis:
#
# Copyright 2023-2025 Audinate Pty Ltd and/or its licensors
#
#

variable "ddm_configuration" {
  type = object({
    api_key      = string
    api_host     = string
    dante_domain = string
  })
  description = <<-EOT
    ddm_configuration = {
      api_key      = "The API key to use while performing the configuration"
      api_host     = "The full name (including protocol, host, port and path) of the location of DDM API"
      dante_domain = "The dante domain to use, must be pre-provisioned"
    }
  EOT
}

variable "enroll_device" {
  type        = bool
  default     = false
  description = "True iff the device must be enrolled into the dante domain passed with the DDM configuration"
}

variable "ip_address" {
  type        = string
  nullable    = false
  description = "The IP address of the device which must be enrolled. This IP address is used to match the device within the DDM"
}