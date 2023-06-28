<!-- Copyright 2023 Audinate Pty Ltd and/or its licensors -->

# Auto Licensing Example

This example illustrates how to create instances of Dante Virtual Soundcard and Dante Gateway for Dante Connect.

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
| <a name="module_dvs"></a> [dvs](#module\_dvs) | ../../modules/virtual-soundcard | n/a |
| <a name="module_dgw"></a> [dgw](#module\_gateway) | ../../modules/gateway | n/a |


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC ID the instances will be created in | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The VPC Subnet ID the instances will be launched in | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region to create the instances in | `string` | n/a | yes |

<!-- END_TF_DOCS -->
