#
# File : data.tf
# Created : April 2023
# Authors :
# Synopsis:
#
# Copyright 2023-2025 Audinate Pty Ltd and/or its licensors
#
#
# Retrieve the most recent AMI which matches the given filters
# Retrieved AMI is used to create instances of the DVS, thus it must meet DVS's system requirements
data "aws_ami" "windows" {

  most_recent = true

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "name"
    values = ["Windows_Server-2022-English-Full-Base-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }

  owners = ["amazon", "aws-marketplace"]
}