#
# File : variables.tf
# Created : April 2023
# Authors :
# Synopsis:
#
# Copyright 2023-2025 Audinate Pty Ltd and/or its licensors
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
  description = "(Optional) List of security group IDs the DVS instance will be associated with"
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
  description = "(Optional) Name of the key pair to use to connect to the instance"
  type        = string
  default     = null
  nullable    = true
}

variable "license_key" {
  description = "The DVS license provided by Audinate"
  type        = string
  sensitive   = true
  nullable    = true
  default     = null
}

variable "ddm_address" {
  type = object({
    hostname = optional(string, "")
    ip       = string
    port     = optional(string, "8000")
  })
  nullable    = true
  default     = null
  description = <<-EOT
    (Optional) Must be provided in case DDM DNS Discovery is not set-up.
    If provided, the ip is required, the port defaults to 8000 and the hostname is optional.
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
    (Optional) When the DDM configuration is passed, the created node will automatically be enrolled into the dante domain
    and configured for unicast clocking. This requires the local environment to be Unix or a Linux-like environment on Windows (such as WSL, Cygwin or MinGW)
    ddm_configuration = {
      api_key      = "The API key to use while performing the configuration"
      api_host     = "The full name (including protocol, host, port and path) of the location of DDM API"
      dante_domain = "The dante domain to use, must be pre-provisioned"
    }
  EOT
}

variable "license_server" {
  type = object({
    hostname = string
    api_key  = string
  })
  nullable = false
  default = {
    hostname = "https://software-license-danteconnect.svc.audinate.com"
    api_key  = "638hPLfZd3nvZ4tXP"
  }

  validation {
    condition     = var.license_server != null ? ((var.license_server.api_key != null) && (var.license_server.hostname != null)) : true
    error_message = "When overriding BOTH the hostname and api key must be provided."
  }

}

variable "audio_driver" {
  description = "(Optional) The audio driver format to be used."
  type        = string
  default     = "asio"
  nullable    = false
  validation {
    condition     = contains(["asio", "wdm"], var.audio_driver)
    error_message = "Invalid DVS audio driver. Valid values = [asio, wdm]"
  }
}

variable "channel_count" {
  description = "(Optional) The number of channels"
  type        = number
  default     = null
  nullable    = true
  validation {
    condition     = var.channel_count != null ? contains([2, 4, 8, 16, 32, 48, 64, 128, 192, 256], var.channel_count) : true
    error_message = "Invalid DVS channel count. Valid values = [2, 4, 8, 16, 32, 48, 64, 128, 192, 256]"
  }
}

variable "licensed_channel_count" {
  description = "(Optional) The number of licensed channels"
  type        = number
  default     = null
  nullable    = true
  validation {
    condition     = var.licensed_channel_count != null ? contains([64, 256], var.licensed_channel_count) : true
    error_message = "Invalid DVS licensed channel count. Valid values = [64, 256]"
  }
}

variable "latency" {
  description = "(Optional) The latency threshold in milliseconds"
  type        = number
  default     = 10
  nullable    = false
  validation {
    condition     = contains([4, 6, 10, 20, 40], var.latency)
    error_message = "Invalid DVS latency. Valid values = [4, 6, 10, 20, 40]"
  }
}

variable "install_reaper" {
  description = "(Optional) True to install REAPER on the DVS for advanced testing"
  type        = bool
  default     = false
}

variable "volume_size" {
  description = "(Optional) Size of the volume in gibibytes (GiB)"
  type        = number
  default     = null
}

variable "environment" {
  description = "The name of the environment"
  type        = string
}

variable "dvs_version" {
  description = "(Deprecated) The version of the DVS to be installed"
  type        = string
  default     = null
}

variable "installer_version" {
  description = "The version of the DVS to be installed"
  type        = string
  nullable    = false
  default     = "4.5.0.5"
}

variable "resource_url" {
  description = "The url to download the DVS installer and tools"
  type        = string
  nullable    = false
  default     = "https://audinate-dante-connect.sgp1.cdn.digitaloceanspaces.com/dvs"
}

variable "associate_public_ip_address" {
  description = "(Optional) True when the instance must be associated with a public IP address"
  type        = bool
  default     = true
}
