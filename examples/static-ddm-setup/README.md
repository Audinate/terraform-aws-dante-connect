<!-- Copyright 2023 Audinate Pty Ltd and/or its licensors -->

# Auto Licensing with Static DDM Example

This example illustrates how to create instances of Dante Virtual Soundcard and Dante Gateway for Dante Connect and associate the instances with a DDM when DNS discovery has not been configured.  
Following initialization, the devices can be manually enrolled via the DDM, and need to be manually forgotten or unenrolled once they are no longer needed.

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
| <a name="module_dgw"></a> [dgw](#module\_dgw) | ../../modules/gateway | n/a |


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC ID the instances will be created in | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The VPC Subnet ID the instances will be launched in | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region to create the instances in | `string` | n/a | yes |
| <a name="input_ddm_hostname"></a> [ddm\_hostname](#input\_ddm\_hostname) | (Optional) The hostname of the DDM. Used to contact the DDM if IP changes | `string` | n/a | no |
| <a name="input_ddm_ip"></a> [ddm\_ddm\_ip](#input\_ddm\_ip) | The private IPv4 of the DDM | `string` | n/a | yes |
| <a name="input_ddm_port"></a> [ddm\_port](#input\_ddm\_port) | The port of the DDM used for device communication. Only necessary if the DDM has been reconfigured to use a port other than 8000 for device communication. | `string` | n/a | no |


<!-- END_TF_DOCS -->