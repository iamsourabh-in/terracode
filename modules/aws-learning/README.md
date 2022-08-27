<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_attachment.asg_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_attachment) | resource |
| [aws_autoscaling_group.launch_template_asg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_budgets_budget.ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/budgets_budget) | resource |
| [aws_cloudwatch_metric_alarm.alarm_cpu_utilization](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_iam_group.user_groups](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group) | resource |
| [aws_iam_user.users](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user_group_membership.users_group_membership](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_group_membership) | resource |
| [aws_launch_template.ec2_launch_template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_lb.my-frontend-alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.front_end](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.alb_target_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_security_group.ec_launch_template_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |

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