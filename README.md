## Modules

A collection of Terraform modules to create instances of selected Dante Connect components:

* [Dante Gateway](modules/gateway)
* [Dante Virtual Soundcard](modules/virtual-soundcard)
* [Remote Monitor](modules/remote-monitor)
* [Remote Contributor](modules/remote-contributor)

## Examples

Examples for licensing and DDM enrollment

* [Minimal Setup](examples/minimal-setup/)
* [Static DDM Setup](examples/static-ddm-setup/)
* [Auto Enrollment in Discovered DDM](examples/auto-enrollment-in-discovered-ddm/)
* [Initialisation in Multiple Regions](examples/multi-region-setup/)

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Bug Reports & Feature Requests
Please use the [issue tracker](https://github.com/Audinate/terraform-aws-dante-connect/issues) to report any bugs or file feature requests for Dante Connect Terraform scripts.

## Support
Support enquiries may be lodged via the Audinate website https://www.audinate.com/contact/support or via email to support@audinate.com.

## Copyright
Copyright © 2024 Audinate Pty Ltd and/or its licensors

## License
[Mozilla Public License v2.0](./LICENSE)
