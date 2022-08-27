# terracode
An approach to aws using terraform



aws ec2 describe-images --owners self amazon
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

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_budget"></a> [aws\_budget](#input\_aws\_budget) | n/a | <pre>object({<br>    name   = string<br>    amount = number,<br>    alert_email = list(string)<br>  })</pre> | <pre>{<br>  "alert_email": [<br>    "devcache.in@gmail.com"<br>  ],<br>  "amount": 5,<br>  "name": "AWS Initial Budget"<br>}</pre> | no |
| <a name="input_aws_subnets"></a> [aws\_subnets](#input\_aws\_subnets) | n/a | `list(string)` | <pre>[<br>  "subnet-0a34eb5e71a6cc12a",<br>  "subnet-0bf29c71441b0bd60",<br>  "subnet-0e670b2abaedd810e",<br>  "subnet-086e62600ebda72b8"<br>]</pre> | no |
| <a name="input_default_eu1_vpc_id"></a> [default\_eu1\_vpc\_id](#input\_default\_eu1\_vpc\_id) | n/a | `string` | `"vpc-01a64cf9cdf93488d"` | no |
| <a name="input_user_groups"></a> [user\_groups](#input\_user\_groups) | n/a | `list(string)` | <pre>[<br>  "dev",<br>  "qa"<br>]</pre> | no |
| <a name="input_users"></a> [users](#input\_users) | n/a | <pre>list(object({<br>    name  = string<br>    group = string<br>  }))</pre> | <pre>[<br>  {<br>    "group": "qa",<br>    "name": "srustag_dev"<br>  },<br>  {<br>    "group": "qa",<br>    "name": "srustag_qa"<br>  }<br>]</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->