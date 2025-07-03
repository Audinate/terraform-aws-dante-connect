#
# Copyright 2023-2025 Audinate Pty Ltd and/or its licensors
#
#
terraform {
  required_version = ">= 1.3.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}