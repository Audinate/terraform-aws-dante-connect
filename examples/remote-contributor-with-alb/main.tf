#
# Copyright 2024-2025 Audinate Pty Ltd and/or its licensors
#
#
locals {
  environment = "test"
  create_lbs  = length(var.subnet_ids) > 1 && var.certificate_arn != null ? true : false
}

module "remote-contributor" {
  count             = 1
  source            = "../../modules/remote-contributor"
  environment       = local.environment
  vpc_id            = var.vpc_id
  subnet_id         = var.subnet_ids[0]
  installer_version = var.rc_version

  create_alb             = local.create_lbs
  alb_public_subnets_ids = var.subnet_ids
  alb_certificate_arn    = var.certificate_arn

  web_admin_account = {
	email = var.web_admin_email
	password = var.web_admin_password
  }
}

resource "aws_route53_record" "remote_contributor_cname_route53_record" {
  count   = 1
  zone_id = var.zone_id
  name    = "remote_contributor-${count.index}"
  type    = "CNAME"
  ttl     = "60"
  records = [module.remote-contributor[count.index].alb_dns_name]
}
