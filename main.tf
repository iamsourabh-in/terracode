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
