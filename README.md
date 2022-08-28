# terracode
An approach to aws using terraform

## Examples

```sh
module "ec2-apache-server" {
  source = "./modules/ec2-apache-server"
  instance_name = "my-first-apache-server"
  ami_id = ["ami-06489866022e12a14"]
  default_vpc_id = "vpc-01b2052d526f0a5f6"
}

```



<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.27 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.75.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ec2-apache-server"></a> [ec2-apache-server](#module\_ec2-apache-server) | ./modules/ec2-apache-server | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->