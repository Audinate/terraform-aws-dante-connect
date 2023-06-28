#
# File : versions.tf
# Created : April 2023
# Authors :
# Synopsis:
#
# Copyright 2023 Audinate Pty Ltd and/or its licensors
#
#
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}