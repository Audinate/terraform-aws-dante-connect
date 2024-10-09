#
# Copyright 2024 Audinate Pty Ltd and/or its licensors
#
#
locals {
  environment = "test"
  create_lbs  = length(var.subnet_ids) > 1 && var.certificate_arn != null ? true : false
}

module "remote-monitor" {
  count             = 1
  source            = "../../modules/remote-monitor"
  environment       = local.environment
  vpc_id            = var.vpc_id
  subnet_id         = var.subnet_ids[0]
  installer_version = var.rm_version

  create_alb             = local.create_lbs
  alb_public_subnets_ids = var.subnet_ids
  alb_certificate_arn    = var.certificate_arn

  web_admin_account = {
	email = var.web_admin_email
	password = var.web_admin_password
  }
}

resource "aws_route53_record" "remote_monitor_cname_route53_record" {
  count   = 1
  zone_id = var.zone_id
  name    = "remote_monitor-${count.index}"
  type    = "CNAME"
  ttl     = "60"
  records = [module.remote-monitor[count.index].alb_dns_name]
}
