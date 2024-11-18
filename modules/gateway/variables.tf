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
  description = "(Optional) Instance type to use for the DGW instance. Updates to this field will trigger a stop/start of the instance"
  type        = string
  default     = "m5.large"
  nullable    = false
}

variable "vpc_security_group_ids" {
  description = "(Optional) List of security group IDs the DGW instance will be associated with"
  type        = list(string)
  default     = null
  nullable    = true
}

variable "subnet_id" {
  description = "The VPC Subnet ID the DGW instance will be launched in"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID the DGW instance will be created in"
  type        = string
}

variable "key_name" {
  description = "(Optional) Name of the key pair to use to connect to the instance"
  type        = string
  default     = null
  nullable    = true
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
  nullable    = true
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

variable "audio_settings" {
  type = object({
    txChannels  = number
    rxChannels  = number
    txLatencyUs = number
    rxLatencyUs = number
  })
  default     = null
  nullable    = true
  description = <<-EOT
    (Optional) the audio settings in the following format:
    audio_settings = {
      txChannels  = "The number of TX channels"
      rxChannels  = "The number of RX channels"
      txLatencyUs = "Asymmetric latency for TX in microseconds"
      rxLatencyUs = "Asymmetric latency for RX in microseconds"
    }
  EOT
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

variable "dgw_version" {
  description = "(Deprecated) The version of the DGW to be installed"
  type        = string
  default     = null
}

variable "installer_version" {
  description = "The version of the DGW to be installed"
  type        = string
  nullable    = false
  default     = "1.1.1.1"
}

variable "resource_url" {
  description = "The url to download a DGW installer"
  type        = string
  nullable    = false
  default     = "https://soda-dante-connect.s3.ap-southeast-2.amazonaws.com/dgw"
}

variable "associate_public_ip_address" {
  description = "(Optional) True when the instance must be associated with a public IP address"
  type        = bool
  default     = true
}

variable "license_key" {
  description = "The DGW license provided by Audinate"
  type        = string
  sensitive   = true
  nullable    = true
  default     = null
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
  description = <<-EOT
    (Optional) License settings
    "license_server" = {
      hostname      = "License server hostname"
      api_key     = "License server api key"
    }
  EOT
}

variable "license_websocket_port" {
  description = "License websocket port number"
  type        = number
  nullable    = false
  default     = 49999
}

variable "licensed_channel_count" {
  description = "(Optional) The number of licensed channels"
  type        = number
  default     = null
  nullable    = true
  validation {
    condition     = var.licensed_channel_count != null ? contains([64, 256], var.licensed_channel_count) : true
    error_message = "Invalid DGW licensed channel count. Valid values = [64, 256]"
  }
}
