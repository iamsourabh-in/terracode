# terracode
An approach to aws using terraform

## Examples

```sh

# apache server
module "ec2-apache-server" {
  source = "./modules/ec2-apache-server"
  instance_name = "my-first-apache-server"
  ami_id = ["ami-06489866022e12a14"]
  default_vpc_id = "vpc-01b2052d526f0a5f6"
}

# ec2 autoscalling simple
module "ec2-asg-infra" {
  source = "./modules/ec2-asg-infra"
  ec_infra_ami_id = ["ami-06489866022e12a14"]
  default_vpc_id = "vpc-01b2052d526f0a5f6"
}

#Generate Randoms

module "random" {
  source = "./modules/random-generator"
  generate_uuid = true
}


```



<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.27 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.13.1 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.3.2 |
| <a name="requirement_time"></a> [time](#requirement\_time) | 0.8.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.75.2 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.13.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ec2-apache-server"></a> [ec2-apache-server](#module\_ec2-apache-server) | ./modules/ec2-apache-server | n/a |
| <a name="module_ec2-asg-infra"></a> [ec2-asg-infra](#module\_ec2-asg-infra) | ./modules/ec2-asg-infra | n/a |
| <a name="module_random"></a> [random](#module\_random) | ./modules/random-generator | n/a |

## Resources

| Name | Type |
|------|------|
| [kubernetes_namespace.example](https://registry.terraform.io/providers/hashicorp/kubernetes/2.13.1/docs/resources/namespace) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->