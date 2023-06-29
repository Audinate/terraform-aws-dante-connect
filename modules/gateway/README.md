<!-- Copyright 2023 Audinate Pty Ltd and/or its licensors -->

# Dante Gateway

Terraform module, which creates instances of the Dante Gateway.

## Example Usage

### DGW basic instance

Creates an instance with a fresh installation of the Dante Gateway.

```hcl
module "dgw" {
  source        = "github.com/Audinate/terraform-aws-dante-connect//modules/gateway"
  environment   = "test"
  subnet_id     = "subnet-01234567890abcdef"
  vpc_id        = "vpc-01234567890abcdef"
}
```

### DGW with static DDM addressing by IP

Creates an instance of the Dante Gateway which references the Dante Domain Manager by IP.
Static addressing must be configured in case the DDM discovery is not set up.

```hcl
module "dgw" {
  source      = "github.com/Audinate/terraform-aws-dante-connect//modules/gateway"
  environment = "test"
  subnet_id   = "subnet-01234567890abcdef"
  vpc_id      = "vpc-01234567890abcdef"
  ddm_address = {
    ip   = "10.0.1.123"
  }
}
```

### DGW with static DDM addressing by hostname and port

Creates an instance of the Dante Gateway which references the Dante Domain Manager by hostname and port. DDM uses port 8000 by default, but if it has been reconfigured you will need to provide a different port number here.
Static addressing must be configured in case the DDM discovery is not set up.

```hcl
module "dgw" {
  source      = "github.com/Audinate/terraform-aws-dante-connect//modules/gateway"
  environment = "test"
  subnet_id   = "subnet-01234567890abcdef"
  vpc_id      = "vpc-01234567890abcdef"
  ddm_address = {
    hostname = "i-10-24-34-0.eu-west-1.compute.internal"
    ip       = "10.0.1.123"
    port     = "8000"
  }
}
```

### DGW with DDM configuration for auto-enrollment

Creates an instance of the Dante Gateway which auto-enrolls in the provided Dante domain.

```hcl
module "dgw" {
  source            = "github.com/Audinate/terraform-aws-dante-connect//modules/gateway"
  environment       = "test"
  subnet_id         = "subnet-01234567890abcdef"
  vpc_id            = "vpc-01234567890abcdef"
  ddm_configuration = {
    api_key      = "404c1e8f-c263-4d78-9920-1268f42aadb8"
    api_host     = "https://ec2-12-345-678-987.eu-west-1.compute.amazonaws.com:4000/graphql"
    dante_domain = "tf-test"
  }
}
```

### DGW with custom audio settings

Creates an instance of the Dante Gateway with customised audio settings.

```hcl
module "dgw" {
  source         = "github.com/Audinate/terraform-aws-dante-connect//modules/gateway"
  environment    = "test"
  subnet_id      = "subnet-01234567890abcdef"
  vpc_id         = "vpc-01234567890abcdef"
  audio_settings = {
    txChannels  = 64
    rxChannels  = 64
    txLatencyUs = 10000
    rxLatencyUs = 100000
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_dgw"></a> [dgw](#module\_dgw) | ../common-modules/ec2/instance | n/a |
| <a name="module_dgw_ddm_script"></a> [dgw\_ddm\_script](#module\_dgw\_ddm\_script) | ../configuration | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_security_group.dgw_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [random_id.random](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [cloudinit_config.user_data](https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs/data-sources/config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_associate_public_ip_address"></a> [associate\_public\_ip\_address](#input\_associate\_public\_ip\_address) | (Optionally) True when the instance must be associated with a public IP address | `bool` | `true` | no |
| <a name="input_audio_settings"></a> [audio\_settings](#input\_audio\_settings) | (Optionally) the audio settings in the following format:<br>audio\_settings = {<br>  txChannels  = "The number of TX channels"<br>  rxChannels  = "The number of RX channels"<br>  txLatencyUs = "Asymmetric latency for TX in microseconds"<br>  rxLatencyUs = "Asymmetric latency for RX in microseconds"<br>} | <pre>object({<br>    txChannels  = number<br>    rxChannels  = number<br>    txLatencyUs = number<br>    rxLatencyUs = number<br>  })</pre> | `null` | no |
| <a name="input_ddm_address"></a> [ddm\_address](#input\_ddm\_address) | (Optionally) Must be provided in case DDM DNS Discovery is not set-up.<br>If provided, the ip is required, the port defaults to 8000 and the hostname is optional.<br>If the hostname is provided, it will be used by supported Dante devices to contact the DDM in case of IP change.<br>ddm\_address = {<br>  hostname = "The hostname of the DDM"<br>  ip    = "The IPv4 of the DDM"<br>  port  = "The port of the DDM"<br>} | <pre>object({<br>    hostname = optional(string, "")<br>    ip       = string<br>    port     = optional(string, "8000")<br>  })</pre> | `null` | no |
| <a name="input_ddm_configuration"></a> [ddm\_configuration](#input\_ddm\_configuration) | (Optionally) When the DDM configuration is passed, the created node will automatically be enrolled into the dante domain<br>and configured for unicast clocking<br>ddm\_configuration = {<br>  api\_key      = "The API key to use while performing the configuration"<br>  api\_host     = "The full name (including protocol, host, port and path) of the location of DDM API"<br>  dante\_domain = "The dante domain to use, must be pre-provisioned"<br>} | <pre>object({<br>    api_key      = string<br>    api_host     = string<br>    dante_domain = string<br>  })</pre> | `null` | no |
| <a name="input_dgw_version"></a> [dgw\_version](#input\_dgw\_version) | (Optionally) The version of the DGW to be installed| `string` | `"1.0.0.2"` | no |
| <a name="input_entitlement_id"></a> [entitlement\_id](#input\_entitlement\_id) | n/a | `string` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The name of the environment | `string` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | (Optionally) Instance type to use for the DGW instance. Updates to this field will trigger a stop/start of the instance | `string` | `"m5.large"` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | (Optionally) Name of the key pair to use to connect to the instance | `string` | `null` | no |
| <a name="input_license_key"></a> [license\_key](#input\_license\_key) | The DGW license provided by Audinate | `string` | `null` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The VPC Subnet ID the DGW instance will be launched in | `string` | n/a | yes |
| <a name="input_volume_size"></a> [volume\_size](#input\_volume\_size) | (Optionally) Size of the volume in gibibytes (GiB) | `number` | `null` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC ID the DGW instance will be created in | `string` | n/a | yes |
| <a name="input_vpc_security_group_ids"></a> [vpc\_security\_group\_ids](#input\_vpc\_security\_group\_ids) | (Optionally) List of security group IDs the DGW instance will be associated with | `list(string)` | `null` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
