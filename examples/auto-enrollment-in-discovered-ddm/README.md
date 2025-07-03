<!-- Copyright 2023-2025 Audinate Pty Ltd and/or its licensors -->

# Auto Licensing and Enrollment with Discovered DDM Example

This example illustrates how to create instances of Dante Virtual Soundcard and Dante Gateway for Dante Connect and automatically enroll them in a DDM.
The instances will be automatically un-enrolled when destroyed.  
Enrollment and unenrollment are performed locally using a bash script, so this example is only supported on Linux and macOS, or in a Linux-like
environment on Windows (such as WSL, Cygwin or MinGW).
The VPC provided for this example is expected to have DHCP configured with the required DNS records for the DDM

## Prerequisites

The automatic enrollment script in this example relies on the [`jq` package](https://jqlang.github.io/jq/).

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_dgw"></a> [dgw](#module\_dgw) | ../../modules/gateway | n/a |
| <a name="module_dvs_256"></a> [dvs\_256](#module\_dvs\_256) | ../../modules/virtual-soundcard | n/a |
| <a name="module_dvs_64"></a> [dvs\_64](#module\_dvs\_64) | ../../modules/virtual-soundcard | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dante_domain"></a> [dante\_domain](#input\_dante\_domain) | The domain to enroll the device in | `string` | n/a | yes |
| <a name="input_ddm_api_host"></a> [ddm\_api\_host](#input\_ddm\_api\_host) | The DDM API URL | `string` | n/a | yes |
| <a name="input_ddm_api_key"></a> [ddm\_api\_key](#input\_ddm\_api\_key) | DDM API key | `string` | n/a | yes |
| <a name="input_dgw_version"></a> [dgw\_version](#input\_dgw\_version) | (Optional) The version of Dante Gateway to be installed | `string` | `null` | no |
| <a name="input_dvs_version"></a> [dvs\_version](#input\_dvs\_version) | (Optional) The version of DVS to be installed | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | Region the instances will be created in | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The VPC Subnet ID the instances will be launched in | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC ID the instances will be created in | `string` | n/a | yes |
<!-- END_TF_DOCS -->