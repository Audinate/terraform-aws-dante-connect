#
# File : variables.tf
# Created : August 2024
# Authors :
# Synopsis:
#
# Copyright 2024 Audinate Pty Ltd and/or its licensors
#
#
variable "instance_type" {
  type        = string
}

variable "vpc_security_group_ids" {
  type        = list(string)
  nullable    = true
}

variable "subnet_id" {
  type        = string
}

variable "vpc_id" {
  type        = string
}

variable "key_name" {
  type     = string
  nullable = true
}

variable "ddm_address" {
  type = object({
    hostname = string
    ip       = string
    port     = string
  })
  nullable   = true
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
  nullable = true
}

variable "audio_settings" {
  type = object({
    rxChannels  = number
    txChannels  = number
    rxLatencyUs = number
    txLatencyUs = number
  })
  nullable    = true
}

variable "volume_size" {
  type     = number
  nullable = true
}

variable "environment" {
  type = string
}

variable "installer_version" {
  type = string
}

variable "resource_url" {
  type     = string
  nullable = false
}

variable "associate_public_ip_address" {
  type = bool
  }

variable "create_alb" {
  type = bool
  }

variable "alb_public_subnets_ids" {
  type     = list(string)
  nullable = true
}

variable "alb_certificate_arn" {
  type     = string
  nullable = true
}

variable "stun_server_config" {
  type     = string
  nullable = true
}

variable "turn_server_config" {
  type     = list(string)
  nullable = true
}

variable "license_key" {
  type      = string
  sensitive = true
  nullable  = false
}

variable "license_server" {
  type = object({
    hostname = string
    api_key  = string
  })
  nullable = false
}

variable "license_websocket_port" {
  type     = number
  nullable = false
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
    error_message = "Provide the admin email address and password to log in to Remote Monitor/Contributor"
  }
}

variable "product_identifiers" {
  type = object({
    service_name         = string
    product_name         = string
    product_abbreviation = string
  })

  description = "Names of the product to use in automated scripts and instance name"
}