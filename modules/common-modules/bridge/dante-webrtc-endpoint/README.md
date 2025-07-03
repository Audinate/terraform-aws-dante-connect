<!-- Copyright 2024-2025 Audinate Pty Ltd and/or its licensors -->

# Dante-WebRTC Endpoint

Terraform module which creates a parameterised instance of Remote Monitor/Contributor, potentially with an Application Load Balancer.
Not intended for external usage, see Remote Monitor or Contributor READMEs instead.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb"></a> [alb](#module\_alb) | ../alb | n/a |
| <a name="module_dante_webrtc_endpoint_base"></a> [dante\_webrtc\_endpoint\_base](#module\_dante\_webrtc\_endpoint\_base) | ../../ec2/instance | n/a |
| <a name="module_dante_webrtc_endpoint_ddm_script"></a> [dante\_webrtc\_endpoint\_ddm\_script](#module\_dante\_webrtc\_endpoint\_ddm\_script) | ../../../configuration | n/a |
| <a name="module_sg"></a> [sg](#module\_sg) | ../security-group | n/a |

## Resources

| Name | Type |
|------|------|
| [random_id.random](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [cloudinit_config.user_data](https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs/data-sources/config) | data source |
<!-- END_TF_DOCS -->