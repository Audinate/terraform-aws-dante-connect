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
| <a name="module_dgw_region_1"></a> [dgw\_region\_1](#module\_dgw\_region\_1) | ../../modules/gateway | n/a |
| <a name="module_dgw_region_2"></a> [dgw\_region\_2](#module\_dgw\_region\_2) | ../../modules/gateway | n/a |
| <a name="module_dvs_256_region_1"></a> [dvs\_256\_region\_1](#module\_dvs\_256\_region\_1) | ../../modules/virtual-soundcard | n/a |
| <a name="module_dvs_256_region_2"></a> [dvs\_256\_region\_2](#module\_dvs\_256\_region\_2) | ../../modules/virtual-soundcard | n/a |
| <a name="module_dvs_64_region_1"></a> [dvs\_64\_region\_1](#module\_dvs\_64\_region\_1) | ../../modules/virtual-soundcard | n/a |
| <a name="module_dvs_64_region_2"></a> [dvs\_64\_region\_2](#module\_dvs\_64\_region\_2) | ../../modules/virtual-soundcard | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dgw_version"></a> [dgw\_version](#input\_dgw\_version) | (Optional) The version of Dante Gateway to be installed | `string` | `null` | no |
| <a name="input_dvs_version"></a> [dvs\_version](#input\_dvs\_version) | (Optional) The version of DVS to be installed | `string` | `null` | no |
| <a name="input_region_1"></a> [region\_1](#input\_region\_1) | The first region the instances will be created in | `string` | n/a | yes |
| <a name="input_region_2"></a> [region\_2](#input\_region\_2) | The second region the instances will be created in | `string` | n/a | yes |
| <a name="input_subnet_id_1"></a> [subnet\_id\_1](#input\_subnet\_id\_1) | The VPC Subnet ID in region 1 the instances will be launched in | `string` | n/a | yes |
| <a name="input_subnet_id_2"></a> [subnet\_id\_2](#input\_subnet\_id\_2) | The VPC Subnet ID in region 2 the instances will be launched in | `string` | n/a | yes |
| <a name="input_vpc_id_1"></a> [vpc\_id\_1](#input\_vpc\_id\_1) | The VPC ID in region 1 the instances will be created in | `string` | n/a | yes |
| <a name="input_vpc_id_2"></a> [vpc\_id\_2](#input\_vpc\_id\_2) | The VPC ID in region 2 the instances will be created in | `string` | n/a | yes |
<!-- END_TF_DOCS -->
