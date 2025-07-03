#
# File : variables.tf
# Created : April 2023
# Authors :
# Synopsis:
#
# Copyright 2023-2025 Audinate Pty Ltd and/or its licensors
#
#
variable "ami_id" {
  description = "Amazon machine image (AMI) to use for the instance"
  type        = string
}

variable "instance_type" {
  description = "Instance type to use for the instance. Updates to this field will trigger a stop/start of the instance"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs the instance will be associated with"
  type        = list(string)
}

variable "subnet_id" {
  description = "The VPC Subnet ID the instance will be launched in"
  type        = string
}

variable "resolve_resource_name_to_ipv4" {
  description = "Indicates whether to respond to DNS queries for instance hostnames with DNS A records"
  type        = bool
}

variable "key_name" {
  description = "Name of the key pair to use to connect to the instance"
  type        = string
  nullable    = true
}

variable "volume_size" {
  description = "Size of the volume in gibibytes (GiB)"
  type        = number
}

variable "user_data" {
  description = "User data (e.g. script) to provide when launching the instance. Updates to this field will trigger a stop/start of the instance by default"
  type        = string
}

variable "instance_name" {
  description = "The name of the instance"
  type        = string
}

variable "environment" {
  description = "The name of the environment"
  type        = string
}

variable "associate_public_ip_address" {
  description = "Should create public IP"
  type        = bool
}

variable "iam_instance_profile" {
  description = "The name of the Instance Profile to launch the instance with."
  type        = string
  default     = null
}

variable "use_eip" {
  description = "As EIP limits are pretty low, don't use an EIP by default."
  type        = bool
  default     = false
}

variable "source_dest_check" {
  description = "Whether to enable source destination checking for the instance."
  type        = bool
  default     = true
}