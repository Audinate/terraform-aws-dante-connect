<!-- Copyright 2023 Audinate Pty Ltd and/or its licensors -->

# Auto Licensing with Discovered DDM and Multiple Regions Example

This example illustrates how to create instances of Dante Virtual Soundcard and Dante Gateway for Dante Connect in multiple regions.  
If the VPCs provided for this example have DHCP configured with the required DNS records for the DDM, the devices will discover the ddm automatically.
The devices should be manually enrolled after initialization, and need to be manually forgotten or unenrolled once they are no longer needed.

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
| <a name="input_vpc_id_1"></a> [vpc\_id\_1](#input\_vpc\_id\_1) | The VPC in region 1 the instances will be created in | `string` | n/a | yes |
| <a name="input_subnet_id_1"></a> [subnet\_id\_1](#input\_subnet\_id\_1) | The Subnet in region 1 the instances will be launched in | `string` | n/a | yes |
| <a name="input_region_1"></a> [region\_1](#input\_region\_1) | The first region to create instances in | `string` | n/a | yes |
| <a name="input_vpc_id_2"></a> [vpc\_id\_2](#input\_vpc\_id\_2) | The VPC in region 2 the instances will be created in | `string` | n/a | yes |
| <a name="input_subnet_id_2"></a> [subnet\_id\_2](#input\_subnet\_id\_2) | The Subnet in region 2 the instances will be launched in | `string` | n/a | yes |
| <a name="input_region_2"></a> [region\_2](#input\_region\_2) | The second region to create instances in | `string` | n/a | yes |

<!-- END_TF_DOCS -->
