<!-- Copyright 2024 Audinate Pty Ltd and/or its licensors -->

# Remote Contributor

Terraform module, which creates instances of the Remote Contributor.

## Example Usage

### Remote Contributor with fresh installation

Creates an instance with a fresh installation of the Remote Contributor.

```hcl
module "remote_contributor" {
  source            = "github.com/Audinate/terraform-aws-dante-connect//modules/remote-contributor"
  environment       = "test"
  subnet_id         = "subnet-01234567890abcdef"
  vpc_id            = "vpc-01234567890abcdef"
  web_admin_account = {
    email        = "example@example.com"
    password     = "example"
  }
}
```

### Remote Contributor with static DDM addressing by IP and port

Creates an instance of the Remote Contributor component which references the Dante Domain Manager by IP and port.
Static addressing must be configured in case the DDM discovery is not set up.

```hcl
module "remote_contributor" {
  source            = "github.com/Audinate/terraform-aws-dante-connect//modules/remote-contributor"
  environment       = "test"
  subnet_id         = "subnet-01234567890abcdef"
  vpc_id            = "vpc-01234567890abcdef"
  web_admin_account = {
    email        = "example@example.com"
    password     = "example"
  }

  ddm_address       = {
    ip           = "10.0.1.123"
  }
}
```

### Remote Contributor with static DDM addressing by hostname and port

Creates an instance of the Remote Contributor component which references the Dante Domain Manager by hostname and port.
Static addressing must be configured in case the DDM discovery is not set up.

```hcl
module "remote_contributor" {
  source            = "github.com/Audinate/terraform-aws-dante-connect//modules/remote-contributor"
  environment       = "test"
  subnet_id         = "subnet-01234567890abcdef"
  vpc_id            = "vpc-01234567890abcdef"
  web_admin_account = {
    email        = "example@example.com"
    password     = "example"
  }

  ddm_address       = {
    hostname     = "i-10-24-34-0.eu-west-1.compute.internal"
    ip           = "10.0.1.123"
  }
}
```

### Remote Contributor with DDM configuration for auto-enrollment

Creates an instance of the Remote Contributor component which auto-enrolls in the provided Dante domain.

#### Prerequisites

Note that this feature uses bash scripts run locally, i.e. on the same machine as terraform is running. As such this feature can only be used on Linux or MacOS, or in a Linux-like environment on Windows (such as WSL, Cygwin or MinGW). You will need to install the [`jq` package](https://jqlang.github.io/jq/) in your environment. It is available through most package managers.

```hcl
module "remote_contributor" {
  source            = "github.com/Audinate/terraform-aws-dante-connect//modules/remote-contributor"
  environment       = "test"
  subnet_id         = "subnet-01234567890abcdef"
  vpc_id            = "vpc-01234567890abcdef"
  web_admin_account = {
    email        = "example@example.com"
    password     = "example"
  }

  ddm_configuration = {
    api_key      = "404c1e8f-c263-4d78-9920-1268f42aadb8"
    api_host     = "https://ec2-12-345-678-987.eu-west-1.compute.amazonaws.com:4000/graphql"
    dante_domain = "tf-test"
  }
}
```

### Remote Contributor with custom audio settings

Creates an instance of the Remote Contributor component with customised audio settings.

```hcl
module "remote_contributor" {
  source            = "github.com/Audinate/terraform-aws-dante-connect//modules/remote-contributor"
  environment       = "test"
  subnet_id         = "subnet-01234567890abcdef"
  vpc_id            = "vpc-01234567890abcdef"
  web_admin_account = {
    email       = "example@example.com"
    password    = "example"
  }

  audio_settings    = {
    rxChannels  = 64
    rxLatencyUs = 100000
  }
}
```

### Remote Contributor with stun/turn server configuration

Creates an instance of the Remote Contributor component with customised stun/turn server configuration.

```hcl
module "remote_contributor" {
  source             = "github.com/Audinate/terraform-aws-dante-connect//modules/remote-contributor"
  environment        = "test"
  subnet_id          = "subnet-01234567890abcdef"
  vpc_id             = "vpc-01234567890abcdef"
  web_admin_account  = {
    email        = "example@example.com"
    password     = "example"
  }

  turn_server_config = ["turn:<username>:<password>@<host>:<port>?transport=<tcp|udp|tls>"]
  stun_server_config = "stun:a.relay.metered.ca:80"
}
```

### Remote Contributor with ALB

Creates an instance of the Remote Contributor component with an Application Load Balancer in front it (to perform HTTPS termination)

```hcl
module "remote_contributor" {
  source                 = "github.com/Audinate/terraform-aws-dante-connect//modules/remote-contributor"
  environment            = "test"
  subnet_id              = "subnet-01234567890abcdef"
  vpc_id                 = "vpc-01234567890abcdef"
  web_admin_account      = {
    email        = "example@example.com"
    password     = "example"
  }

  create_alb             = true
  alb_public_subnets_ids = ["subnet-01234567890abcdef", "subnet-98765432100ghijkl"]
  alb_certificate_arn    = "arn:aws:acm:eu-west-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"
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
| <a name="module_remote_contributor"></a> [remote\_contributor](#module\_remote\_contributor) | ../common-modules/bridge/dante-webrtc-endpoint | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_certificate_arn"></a> [alb\_certificate\_arn](#input\_alb\_certificate\_arn) | (Optional) Required when create\_alb is true. The certificate ARN to associate with the ALB | `string` | `null` | no |
| <a name="input_alb_public_subnets_ids"></a> [alb\_public\_subnets\_ids](#input\_alb\_public\_subnets\_ids) | (Optional) Required when create\_alb is true. The list of subnets ID's which must be used for the ALB | `list(string)` | `null` | no |
| <a name="input_associate_public_ip_address"></a> [associate\_public\_ip\_address](#input\_associate\_public\_ip\_address) | (Optional) True when the instance must be associated with a public IP address | `bool` | `true` | no |
| <a name="input_audio_settings"></a> [audio\_settings](#input\_audio\_settings) | (Optional) the audio settings in the following format:<br>audio\_settings = {<br>  rxChannels  = "The number of RX channels"<br>  txChannels  = "The nubmer of TX channels"<br>  rxLatencyUs = "Asymmetric latency for RX in microseconds"<br>  txLatencyUs = "Asymmetric latency for TX in microseconds"<br>} | <pre>object({<br>    rxChannels  = number<br>    txChannels  = number<br>    rxLatencyUs = number<br>    txLatencyUs = number<br>  })</pre> | `null` | no |
| <a name="input_create_alb"></a> [create\_alb](#input\_create\_alb) | (Optional) True if an ALB in front of the Remote Contributor must be created (to perform HTTPS termination) | `bool` | `false` | no |
| <a name="input_ddm_address"></a> [ddm\_address](#input\_ddm\_address) | (Optional) Must be provided in case DDM DNS Discovery is not set-up.<br>If provided, the ip is required, the hostname and port are optional.<br>If the hostname is provided, it will be used by supported Dante devices to contact the DDM in case of IP change.<br>ddm\_address = {<br>  hostname = "The hostname of the DDM"<br>  ip    = "The IPv4 of the DDM"<br>  port  = "The port of the DDM"<br>} | <pre>object({<br>    hostname = optional(string, "")<br>    ip       = string<br>    port     = optional(string, "8000")<br>  })</pre> | `null` | no |
| <a name="input_ddm_configuration"></a> [ddm\_configuration](#input\_ddm\_configuration) | (Optional) When the DDM configuration is passed, the created node will automatically be enrolled into the dante domain<br>and configured for unicast clocking. This requires the local environment to be Unix or a Linux-like environment on Windows (such as WSL, Cygwin or MinGW)<br>ddm\_configuration = {<br>  api\_key      = "The API key to use while performing the configuration"<br>  api\_host     = "The full name (including protocol, host, port and path) of the location of DDM API"<br>  dante\_domain = "The dante domain to use, must be pre-provisioned"<br>} | <pre>object({<br>    api_key      = string<br>    api_host     = string<br>    dante_domain = string<br>  })</pre> | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The name of the environment | `string` | n/a | yes |
| <a name="input_installer_version"></a> [installer\_version](#input\_installer\_version) | (Optional) The version of the Remote Contributor to be installed | `string` | `"1.0.0.3"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | (Optional) Instance type to use for the Remote Contributor instance. Updates to this field will trigger a stop/start of the instance | `string` | `"m5.large"` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | (Optional) Name of the key pair to use to connect to the instance | `string` | `null` | no |
| <a name="input_license_key"></a> [license\_key](#input\_license\_key) | The Remote Contributor license provided by Audinate | `string` | `null` | no |
| <a name="input_license_server"></a> [license\_server](#input\_license\_server) | (Optional) License settings<br>license\_server = {<br>  hostname    = "License server hostname"<br>  api\_key     = "License server api key"<br>} | <pre>object({<br>    hostname = string<br>    api_key  = string<br>  })</pre> | <pre>{<br>  "api_key": "638hPLfZd3nvZ4tXP",<br>  "hostname": "https://software-license-danteconnect.svc.audinate.com"<br>}</pre> | no |
| <a name="input_license_websocket_port"></a> [license\_websocket\_port](#input\_license\_websocket\_port) | License websocket port number | `number` | `49999` | no |
| <a name="input_resource_url"></a> [resource\_url](#input\_resource\_url) | The url to download a remote-contributor installer | `string` | `"https://soda-dante-connect.s3.ap-southeast-2.amazonaws.com/remote-contributor"` | no |
| <a name="input_stun_server_config"></a> [stun\_server\_config](#input\_stun\_server\_config) | (Optional) Stun server configuration provided e.g. stun.l.google.com:19302 | `string` | `null` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The VPC Subnet ID the Remote Contributor instance will be launched in | `string` | n/a | yes |
| <a name="input_turn_server_config"></a> [turn\_server\_config](#input\_turn\_server\_config) | (Optional) Turn server configuration provided e.g. [turn:<username>:<password>@<host>:<port>?transport=<tcp\|udp\|tls>, ...] | `list(string)` | `null` | no |
| <a name="input_volume_size"></a> [volume\_size](#input\_volume\_size) | (Optional) Size of the volume in gibibytes (GiB) | `number` | `null` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC ID the Remote Contributor instance will be created in | `string` | n/a | yes |
| <a name="input_vpc_security_group_ids"></a> [vpc\_security\_group\_ids](#input\_vpc\_security\_group\_ids) | (Optional) List of security group IDs the Remote Contributor instance will be associated with | `list(string)` | `null` | no |
| <a name="input_web_admin_account"></a> [web\_admin\_account](#input\_web\_admin\_account) | The account information to log in to Remote Contributor for web administration<br>web\_admin\_account = {<br>  email      = "Admin email address"<br>  password   = "Admin password"<br>} | <pre>object({<br>    email    = string<br>    password = string<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_dns_name"></a> [alb\_dns\_name](#output\_alb\_dns\_name) | n/a |
| <a name="output_ec2_remote_contributor_instance_id"></a> [ec2\_remote\_contributor\_instance\_id](#output\_ec2\_remote\_contributor\_instance\_id) | n/a |
<!-- END_TF_DOCS -->
