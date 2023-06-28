#
# File : variables.tf
# Created : April 2023
# Authors :
# Synopsis:
#
# Copyright 2023 Audinate Pty Ltd and/or its licensors
#
#
variable "instance_type" {
  description = <<EOT
    Instance type to use for the DVS instance. Updates to this field will trigger a stop/start of the instance.
    If not provided, defaults based on the channel count configuration will be used:
    "m5.large" for up to and including 64 channels, "m5.2xlarge" for more than 64 channels.
  EOT
  type        = string
  default     = null
}

variable "vpc_security_group_ids" {
  description = "(Optionally) List of security group IDs the DVS instance will be associated with"
  type        = list(string)
  default     = null
  nullable    = true
}

variable "subnet_id" {
  description = "The VPC Subnet ID the DVS instance will be launched in"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID the DDM instance will be created in"
  type        = string
}

variable "key_name" {
  description = "(Optionally) Name of the key pair to use to connect to the instance"
  type        = string
  default     = null
  nullable    = true
}

variable "license_key" {
  description = "The DVS license provided by Audinate"
  type        = string
  sensitive   = true
  default     = "NISBH-ZQG2O-KAKHZ-XHYWZ-IA32H"
}

variable "ddm_address" {
  type = object({
    hostname = optional(string, "")
    ip       = string
    port     = string
  })
  nullable    = true
  default     = null
  description = <<-EOT
    (Optionally) Must be provided in case DDM DNS Discovery is not set-up.
    If provided, the ip and port are required, the hostname is optional.
    If the hostname is provided, it will be used by supported Dante devices to contact the DDM in case of IP change.
    ddm_address = {
      hostname = "The hostname of the DDM"
      ip    = "The IPv4 of the DDM"
      port  = "The port of the DDM"
    }
  EOT
  validation {
    condition     = var.ddm_address == null ? true : var.ddm_address.ip == "" || can(regex("^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$", var.ddm_address.ip))
    error_message = "Provided IP is not a valid IP version 4 address"
  }
}

variable "ddm_configuration" {
  type = object({
    api_key      = string
    api_host     = string
    dante_domain = string
  })
  default     = null
  description = <<-EOT
    (Optionally) When the DDM configuration is passed, the created node will automatically be enrolled into the dante domain
    and configured for unicast clocking
    ddm_configuration = {
      api_key      = "The API key to use while performing the configuration"
      api_host     = "The full name (including protocol, host, port and path) of the location of DDM API"
      dante_domain = "The dante domain to use, must be pre-provisioned"
    }
  EOT
}

variable "licenseServerConfig" {
  type = object({
    licenseServerHostname = string
    licenseServerApiKey   = string
  })
  nullable = true
  default  = {
    licenseServerHostname = "https://software-license-danteconnect.svc.audinate.com"
    licenseServerApiKey   = "638hPLfZd3nvZ4tXP"
  }

  validation {
    condition     = var.licenseServerConfig != null ? ((var.licenseServerConfig.licenseServerApiKey != null) && (var.licenseServerConfig.licenseServerHostname != null)) : true
    error_message = "When overriding BOTH the hostname and api key must be provided."
  }

}

variable "audio_driver" {
  description = "(Optionally) The audio driver format to be used."
  type        = string
  default     = "asio"
  nullable    = false
  validation {
    condition = contains(["asio", "wdm"], var.audio_driver)
    error_message = "Invalid DVS audio driver. Valid values = [asio, wdm]"
  }
}

variable "channel_count" {
  description = "(Optionally) The number of channels"
  type        = number
  default     = 64
  nullable    = false
  validation {
    condition = contains([2, 4, 8, 16, 32, 48, 64, 128, 192, 256], var.channel_count)
    error_message = "Invalid DVS channel count. Valid values = [2, 4, 8, 16, 32, 48, 64, 128, 192, 256]"
  }
}

variable "latency" {
  description = "(Optionally) The latency threshold"
  type        = number
  default     = 10
  nullable    = false
  validation {
    condition = contains([4, 6, 10, 20, 40], var.latency)
    error_message = "Invalid DVS latency. Valid values = [4, 6, 10, 20, 40]"
  }
}

variable "install_reaper" {
  description = "(Optionally) True to install REAPER on the DVS for advanced testing"
  type        = bool
  default     = false
}

variable "volume_size" {
  description = "(Optionally) Size of the volume in gibibytes (GiB)"
  type        = number
  default     = null
}

variable "environment" {
  description = "The name of the environment"
  type        = string
}

variable "dvs_version" {
  description = "The version of the DVS to be installed"
  type        = string
  default     = "4.4.0.3"
}

variable "dvs_resource_url" {
  description = "The url to download the DVS installer and tools"
  type        = string
  default     = "https://soda-dante-connect.s3.ap-southeast-2.amazonaws.com/dvs"
}

variable "associate_public_ip_address" {
  description = "(Optionally) True when the instance must be associated with a public IP address"
  type        = bool
  default     = true
}

