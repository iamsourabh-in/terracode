resource "aws_iam_group" "user_groups" {
  for_each = toset(var.user_groups)
  name     = each.key
}


resource "aws_iam_user" "users" {
  for_each = { for vm in var.users : vm.name => vm }
  name     = each.value.name
  tags = {
    AWSService = "IAM"
    Group = each.value.group
  }
}

resource "aws_iam_user_group_membership" "users_group_membership" {
  for_each = { for vm in aws_iam_user.users : vm.name => vm}
  user     = each.key

  groups = [
     each.value.tags_all.Group
  ]
}

resource "aws_budgets_budget" "ec2" {
  name              = var.aws_budget.name
  budget_type       = "COST"
  limit_amount      = var.aws_budget.amount
  limit_unit        = "USD"
  time_period_end   = "2030-01-01_00:00"
  time_period_start = "2022-01-01_00:00"
  time_unit         = "MONTHLY"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 80
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_email_addresses = var.aws_budget.alert_email
  }
}