#
# File : variables.tf
# Created : April 2023
# Authors :
# Synopsis:
#
# Copyright 2023-2025 Audinate Pty Ltd and/or its licensors
#
#
variable "vpc_id" {
  description = "The VPC ID the Bridge instance will be created in"
  type        = string
}

variable "component_name_abbreviation" {
  description = "The abbreviated name used for the given Bridge"
  type        = string
}

variable "environment" {
  description = "The name of the environment"
  type        = string
}

variable "instance_suffix" {
  description = "The suffix used in the Bridge's instance name"
  type        = string
}

variable "alb_security_groups" {
  description = "(Optionally) ALB security groups to add ingress rules for them"
  type        = list(string)
  nullable    = false
  default     = []
}
