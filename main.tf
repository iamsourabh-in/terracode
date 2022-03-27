resource "aws_iam_group" "user_groups" {
  for_each = toset(var.user_groups)
  name     = each.key
}


resource "aws_iam_user" "users" {
  for_each = { for vm in var.users : vm.name => vm }
  name     = each.value.name
  tags = {
    AWSService = "IAM"
    Group      = each.value.group
  }
}

resource "aws_iam_user_group_membership" "users_group_membership" {
  for_each = { for vm in aws_iam_user.users : vm.name => vm }
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

# Networking

# resource "aws_vpc" "myvpc" {
#   cidr_block       = "10.0.0.0/16"
#   instance_tenancy = "default"

#   tags = {
#     Name = "myvpc"
#     AWSService = "VPC"
#   }
# }

# resource "aws_internet_gateway" "myigw" {
#   vpc_id = aws_vpc.myvpc.id
#   tags = {
#     Name = "myigw"
#   }
# }

# resource "aws_subnet" "my_az1_subnet" {
#   vpc_id     = aws_vpc.myvpc.id
#   cidr_block = "10.0.1.0/24"
#   availability_zone_id = "use1-az1"
#   tags = {
#     Name = "my_az1_subnet"
#   }
# }

# resource "aws_subnet" "my_az2_subnet" {
#   vpc_id     = aws_vpc.myvpc.id
#   cidr_block = "10.0.2.0/24"
#   availability_zone_id = "use1-az2"
#   tags = {
#     Name = "my_az2_subnet"
#   }
# }



resource "aws_security_group" "ec_launch_template_security_group" {
  name        = "ec_launch_template_security_group"
  description = "Allow TLS inbound traffic"
  vpc_id      = "vpc-01a64cf9cdf93488d"

  ingress {
    description = "SSH from Anywhere"
    from_port   = 0
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Http Request from Anywhere"
    from_port   = 0
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh_http"
  }
}

# Ec2 Area



resource "aws_launch_template" "ec_launch_template" {

  name                                 = "ec_launch_template"

  image_id                             = "ami-0c02fb55956c7d316"
  instance_type                        = "t2.micro"
  instance_initiated_shutdown_behavior = "terminate"

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 8

    }
  }
  key_name = "devcache.in"

  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }

  instance_market_options {
    market_type = "spot"
  }
  vpc_security_group_ids = [aws_security_group.ec_launch_template_security_group.id]

  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = {

    }
  }

  user_data = filebase64("${path.module}/scripts/ec2-user-data.sh")
}
