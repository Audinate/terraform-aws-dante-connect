<!-- Copyright 2023-2025 Audinate Pty Ltd and/or its licensors -->

# Dante Virtual Soundcard

Terraform module, which creates instances of the Dante Virtual Soundcard.

## Example Usage

### DVS basic instance

Creates an instance with a fresh installation of the Dante Virtual Soundcard.

```hcl
module "dvs" {
  source        = "github.com/Audinate/terraform-aws-dante-connect//modules/virtual-soundcard"
  environment   = "test"
  subnet_id     = "subnet-01234567890abcdef"
  vpc_id        = "vpc-01234567890abcdef"
}
```

### DVS with static DDM addressing by IP

Creates an instance of the Dante Virtual Soundcard which references the Dante Domain Manager by IP.
Static addressing must be configured in case the DDM discovery is not set up.

```hcl
module "dvs" {
  source      = "github.com/Audinate/terraform-aws-dante-connect//modules/virtual-soundcard"
  environment = "test"
  subnet_id   = "subnet-01234567890abcdef"
  vpc_id      = "vpc-01234567890abcdef"
  ddm_address = {
    ip   = "10.0.1.123"
    port = "8000"
  }
}
```

### DVS with static DDM addressing by hostname and port

Creates an instance of the Dante Virtual Soundcard which references the Dante Domain Manager by hostname and port. DDM uses port 8000 by default, but if it has been reconfigured you will need to provide a different port number here.
Static addressing must be configured in case the DDM discovery is not set up.

```hcl
module "dvs" {
  source      = "github.com/Audinate/terraform-aws-dante-connect//modules/virtual-soundcard"
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

### DVS with DDM configuration for auto-enrollment

Creates an instance of the Dante Virtual Soundcard which auto-enrolls in the provided Dante domain.

#### Prerequisites

Note that this feature uses bash scripts run locally, i.e. on the same machine as terraform is running. As such this feature can only be used on Linux or MacOS, or in a Linux-like environment on Windows (such as WSL, Cygwin or MinGW). You will need to install the [`jq` package](https://jqlang.github.io/jq/) in your environment. It is available through most package managers.

```hcl
module "dvs" {
  source            = "github.com/Audinate/terraform-aws-dante-connect//modules/virtual-soundcard"
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

### DVS with custom audio settings

Creates an instance of the Dante Virtual Soundcard with customised audio settings.

```hcl
module "dvs" {
  source                = "github.com/Audinate/terraform-aws-dante-connect//modules/virtual-soundcard"
  environment           = "test"
  subnet_id             = "subnet-01234567890abcdef"
  vpc_id                = "vpc-01234567890abcdef"
  audio_driver          = "WDM"
  channel_count         = 4
  latency               = 6
}
```
### DVS with overridden license server host name and api key (both should be applied) 

Creates an instance of the Dante Virtual Soundcard with customised license server settings.

```hcl
module "dvs" {
  source                = "github.com/Audinate/terraform-aws-dante-connect//modules/virtual-soundcard"
  environment           = "test"
  subnet_id             = "subnet-01234567890abcdef"
  vpc_id                = "vpc-01234567890abcdef"
  license_server   = {
    hostname = "http://exampleABCD.seting.com"
    api_key   = "someApiKeyProvided"
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
| <a name="module_dvs"></a> [dvs](#module\_dvs) | ../common-modules/ec2/instance | n/a |
| <a name="module_dvs_ddm_script"></a> [dvs\_ddm\_script](#module\_dvs\_ddm\_script) | ../configuration | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_security_group.dvs_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [random_id.random](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [aws_ami.windows](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_associate_public_ip_address"></a> [associate\_public\_ip\_address](#input\_associate\_public\_ip\_address) | (Optional) True when the instance must be associated with a public IP address | `bool` | `true` | no |
| <a name="input_audio_driver"></a> [audio\_driver](#input\_audio\_driver) | (Optional) The audio driver format to be used. | `string` | `"asio"` | no |
| <a name="input_channel_count"></a> [channel\_count](#input\_channel\_count) | (Optional) The number of channels | `number` | `null` | no |
| <a name="input_ddm_address"></a> [ddm\_address](#input\_ddm\_address) | (Optional) Must be provided in case DDM DNS Discovery is not set-up.<br>If provided, the ip is required, the port defaults to 8000 and the hostname is optional.<br>If the hostname is provided, it will be used by supported Dante devices to contact the DDM in case of IP change.<br>ddm\_address = {<br>  hostname = "The hostname of the DDM"<br>  ip    = "The IPv4 of the DDM"<br>  port  = "The port of the DDM"<br>} | <pre>object({<br>    hostname = optional(string, "")<br>    ip       = string<br>    port     = optional(string, "8000")<br>  })</pre> | `null` | no |
| <a name="input_ddm_configuration"></a> [ddm\_configuration](#input\_ddm\_configuration) | (Optional) When the DDM configuration is passed, the created node will automatically be enrolled into the dante domain<br>and configured for unicast clocking. This requires the local environment to be Unix or a Linux-like environment on Windows (such as WSL, Cygwin or MinGW)<br>ddm\_configuration = {<br>  api\_key      = "The API key to use while performing the configuration"<br>  api\_host     = "The full name (including protocol, host, port and path) of the location of DDM API"<br>  dante\_domain = "The dante domain to use, must be pre-provisioned"<br>} | <pre>object({<br>    api_key      = string<br>    api_host     = string<br>    dante_domain = string<br>  })</pre> | `null` | no |
| <a name="input_dvs_version"></a> [dvs\_version](#input\_dvs\_version) | (Deprecated) The version of the DVS to be installed | `string` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The name of the environment | `string` | n/a | yes |
| <a name="input_install_reaper"></a> [install\_reaper](#input\_install\_reaper) | (Optional) True to install REAPER on the DVS for advanced testing | `bool` | `false` | no |
| <a name="input_installer_version"></a> [installer\_version](#input\_installer\_version) | The version of the DVS to be installed | `string` | `"4.5.0.5"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type to use for the DVS instance. Updates to this field will trigger a stop/start of the instance.<br>    If not provided, defaults based on the channel count configuration will be used:<br>    "m5.large" for up to and including 64 channels, "m5.2xlarge" for more than 64 channels. | `string` | `null` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | (Optional) Name of the key pair to use to connect to the instance | `string` | `null` | no |
| <a name="input_latency"></a> [latency](#input\_latency) | (Optional) The latency threshold in milliseconds | `number` | `10` | no |
| <a name="input_license_key"></a> [license\_key](#input\_license\_key) | The DVS license provided by Audinate | `string` | `null` | no |
| <a name="input_license_server"></a> [license\_server](#input\_license\_server) | n/a | <pre>object({<br>    hostname = string<br>    api_key  = string<br>  })</pre> | <pre>{<br>  "api_key": "638hPLfZd3nvZ4tXP",<br>  "hostname": "https://software-license-danteconnect.svc.audinate.com"<br>}</pre> | no |
| <a name="input_licensed_channel_count"></a> [licensed\_channel\_count](#input\_licensed\_channel\_count) | (Optional) The number of licensed channels | `number` | `null` | no |
| <a name="input_resource_url"></a> [resource\_url](#input\_resource\_url) | The url to download the DVS installer and tools | `string` | `"https://audinate-dante-connect.sgp1.cdn.digitaloceanspaces.com/dvs"` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The VPC Subnet ID the DVS instance will be launched in | `string` | n/a | yes |
| <a name="input_volume_size"></a> [volume\_size](#input\_volume\_size) | (Optional) Size of the volume in gibibytes (GiB) | `number` | `null` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC ID the DDM instance will be created in | `string` | n/a | yes |
| <a name="input_vpc_security_group_ids"></a> [vpc\_security\_group\_ids](#input\_vpc\_security\_group\_ids) | (Optional) List of security group IDs the DVS instance will be associated with | `list(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dvs_instance_name"></a> [dvs\_instance\_name](#output\_dvs\_instance\_name) | Name of Dante Virtual Soundcard EC2 instance |
| <a name="output_dvs_private_ip"></a> [dvs\_private\_ip](#output\_dvs\_private\_ip) | Private IP of the Dante Virtual Soundcard instance |
<!-- END_TF_DOCS -->
