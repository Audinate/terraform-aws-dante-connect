<!-- Copyright 2023 Audinate Pty Ltd and/or its licensors -->

# Audinate Dante Connect Terraform Module

This is a collection of submodules that make it easier to create instances of selected Dante Connect components:

* [Dante Gateway](gateway)
* [Dante Virtual Soundcard](virtual-soundcard)
* [Remote Monitor](remote-monitor)
* [Remote Contributor](remote-contributor)

## Features

The following features are available for all submodules:

* Optionally specify the instance type
* Optionally specify the instance volume size
* Optionally specify security groups the instance will be associated with
* Optionally specify whether a public IP address should be assigned to the instance
* Optionally specify a key-pair which can be used to connect to the instance
* Optionally specify the version of the given Dante Connect component to be used

## Instance count & destruction

Since Terraform 0.13, [the `count` meta-argument](https://developer.hashicorp.com/terraform/language/meta-arguments/count) can be used on modules.
Here's an example how to use the `count` meta-argument to create two instances of the Dante Virtual Soundcard:

```hcl
module "dvs" {
  source = "github.com/Audinate/terraform-aws-dante-connect//modules/virtual-soundcard"
  count  = 2

  environment = "test"
  subnet_id   = "subnet-01234567890abcdef"
  vpc_id      = "vpc-01234567890abcdef"
}
```

In order to destroy all instances of a certain Dante Connect component, 
either remove the module block from your `main.tf` file or set the count to zero:

```hcl
module "dvs" {
  source = "github.com/Audinate/terraform-aws-dante-connect//modules/virtual-soundcard"
  count  = 0

  environment = "test"
  subnet_id   = "subnet-01234567890abcdef"
  vpc_id      = "vpc-01234567890abcdef"
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Bug Reports & Feature Requests
Please use the [issue tracker](https://github.com/terraform-audinate-modules/terraform-aws-dante-connect/issues) to report any bugs or file feature requests.

## Copyright
Copyright © 2023 Audinate Pty Ltd and/or its licensors
