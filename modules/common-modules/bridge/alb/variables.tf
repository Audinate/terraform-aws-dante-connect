#
# File : variables.tf
# Created : April 2023
# Authors :
# Synopsis:
#
# Copyright 2023 Audinate Pty Ltd and/or its licensors
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

variable "alb_public_subnets_ids" {
  description = "The list of subnets ID's which must be used for the ALB"
  type        = list(string)
}

variable "alb_certificate_arn" {
  description = "The certificate ARN to associate with the ALB"
  type        = string
}

variable "bridge_instance_id" {
  description = "The Bridge's instance ID to associate with the ALB"
  type        = string
}
