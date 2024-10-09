#
# Copyright 2024 Audinate Pty Ltd and/or its licensors
#
#

variable "subnet_ids" {
  description = "The list of VPC Subnet IDs the instances will be launched in"
  type        = list(string)
}

variable "vpc_id" {
  description = "The VPC ID the instances will be created in"
  type        = string
}

variable "region" {
  description = "Region the instances will be created in"
  type        = string
}

variable "rc_version" {
  description = "(Optional) The version of Remote Contributor to be installed"
  type        = string
  default     = null
}

variable "certificate_arn" {
  description = "The certificate ARN to associate with the application load balancer"
  type        = string
}

variable "zone_id" {
  description = "The ID of the Route53 hosted zone where the CNAME records of Remote Contributor instances are stored"
  type        = string
}

variable "web_admin_email" {
  description = "The admin email address to log in to Remote Contributor"
  type        = string
  sensitive   = true
}

variable "web_admin_password" {
  description = "The admin password to log in to Remote Contributor"
  type        = string
  sensitive   = true
}
