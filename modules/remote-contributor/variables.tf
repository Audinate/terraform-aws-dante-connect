#
# File : variables.tf
# Created : August 2024
# Authors :
# Synopsis:
#
# Copyright 2024-2025 Audinate Pty Ltd and/or its licensors
#
#
variable "instance_type" {
  description = "(Optional) Instance type to use for the Remote Contributor instance. Updates to this field will trigger a stop/start of the instance"
  type        = string
  default     = "m5.large"
  nullable    = false
}

variable "vpc_security_group_ids" {
  description = "(Optional) List of security group IDs the Remote Contributor instance will be associated with"
  type        = list(string)
  nullable    = true
  default     = null
}

variable "subnet_id" {
  description = "The VPC Subnet ID the Remote Contributor instance will be launched in"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID the Remote Contributor instance will be created in"
  type        = string
}

variable "key_name" {
  description = "(Optional) Name of the key pair to use to connect to the instance"
  type        = string
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
    If provided, the ip is required, the hostname and port are optional.
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

variable "audio_settings" {
  type = object({
    rxChannels  = number
    txChannels  = number
    rxLatencyUs = number
    txLatencyUs = number
  })
  default     = null
  nullable    = true
  description = <<-EOT
    (Optional) the audio settings in the following format:
    audio_settings = {
      rxChannels  = "The number of RX channels"
      txChannels  = "The nubmer of TX channels"
      rxLatencyUs = "Asymmetric latency for RX in microseconds"
      txLatencyUs = "Asymmetric latency for TX in microseconds"
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

variable "installer_version" {
  description = "(Optional) The version of the Remote Contributor to be installed"
  type        = string
  nullable    = false
  default     = "1.0.0.3"
}

variable "resource_url" {
  description = "The url to download a remote-contributor installer"
  type        = string
  nullable    = false
  default     = "https://audinate-dante-connect.sgp1.cdn.digitaloceanspaces.com/remote-contributor"
}

variable "associate_public_ip_address" {
  description = "(Optional) True when the instance must be associated with a public IP address"
  type        = bool
  default     = true
}

variable "create_alb" {
  description = "(Optional) True if an ALB in front of the Remote Contributor must be created (to perform HTTPS termination)"
  type        = bool
  default     = false
}

variable "alb_public_subnets_ids" {
  description = "(Optional) Required when create_alb is true. The list of subnets ID's which must be used for the ALB"
  type        = list(string)
  default     = null
}

variable "alb_certificate_arn" {
  description = "(Optional) Required when create_alb is true. The certificate ARN to associate with the ALB"
  type        = string
  default     = null
}

variable "stun_server_config" {
  description = "(Optional) Stun server configuration provided e.g. stun.l.google.com:19302 "
  type        = string
  default     = null
}

variable "turn_server_config" {
  description = "(Optional) Turn server configuration provided e.g. [turn:<username>:<password>@<host>:<port>?transport=<tcp|udp|tls>, ...] "
  type        = list(string)
  default     = null
}

variable "license_key" {
  description = "The Remote Contributor license provided by Audinate"
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
    license_server = {
      hostname    = "License server hostname"
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

variable "web_admin_account" {
  type = object({
    email    = string
    password = string
  })
  sensitive = true
  nullable  = false
  validation {
    condition     = var.web_admin_account.email != null && var.web_admin_account.password != null
    error_message = "Provide the admin email address and password to log in to Remote Contributor"
  }

  description = <<-EOT
    The account information to log in to Remote Contributor for web administration
    web_admin_account = {
      email      = "Admin email address"
      password   = "Admin password"
    }
  EOT
}
