#
# File : main.tf
# Created : April 2023
# Authors :
# Synopsis:
#
# Copyright 2023-2025 Audinate Pty Ltd and/or its licensors
#
#
resource "null_resource" "enrollment_script" {
  count = var.enroll_device ? 1 : 0

  triggers = {
    private_ip = var.ip_address
    # Note that this requires the state to be securely stored, the keys are stored unencrypted
    api_key      = var.ddm_configuration.api_key
    api_host     = var.ddm_configuration.api_host
    dante_domain = var.ddm_configuration.dante_domain
  }

  provisioner "local-exec" {
    working_dir = "${path.module}/../configuration/setup-scripts/"
    command     = "./enroll-device-into-domain.sh \"${self.triggers.dante_domain}\" ${self.triggers.private_ip}"
    interpreter = ["bash", "-c"]
    environment = {
      API_KEY  = self.triggers.api_key
      API_HOST = self.triggers.api_host
    }
  }
  provisioner "local-exec" {
    when        = destroy
    working_dir = "${path.module}/../configuration/setup-scripts/"
    command     = "./unenroll-device.sh ${self.triggers.private_ip}"
    interpreter = ["bash", "-c"]
    environment = {
      API_KEY  = self.triggers.api_key
      API_HOST = self.triggers.api_host
    }
  }
}