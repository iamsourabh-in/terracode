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


# ---------SecurityGroup (allowing http and ssh)

resource "aws_security_group" "ec_launch_template_security_group" {
  name        = "ec_launch_template_security_group"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.default_eu1_vpc_id
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
  egress {
    description = "Request from Anywhere"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name       = "allow_ssh_http"
    AWSService = "SecurityGroup"
  }
}

resource "aws_lb_target_group" "alb_target_group" {
  name        = "alb-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.default_eu1_vpc_id
  target_type = "instance"
  tags = {
    Name       = "alb-target-group"
    AWSService = "TargetGroup"
  }
}

resource "aws_lb" "my-frontend-alb" {
  name                       = "my-frontend-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.ec_launch_template_security_group.id]
  subnets                    = [for subnet in var.aws_subnets : subnet]
  enable_deletion_protection = false
  tags = {
    AWSService = "ALB"
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.my-frontend-alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}


# Ec2 Area



resource "aws_launch_template" "ec2_launch_template" {
  name                                 = "ec_launch_template"
  image_id                             = "ami-0c02fb55956c7d316"
  instance_type                        = "t2.micro"
  instance_initiated_shutdown_behavior = "terminate"
  vpc_security_group_ids               = [aws_security_group.ec_launch_template_security_group.id]
  key_name                             = "devcache.in"
  user_data                            = filebase64("${path.module}/scripts/ec2-user-data.sh")
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 8
    }
  }
  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }
  monitoring {
    enabled = true
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      AWSService = "LaunchTemplate"
    }
  }
}

resource "aws_autoscaling_group" "launch_template_asg" {
  availability_zones = ["us-east-1a","us-east-1b","us-east-1c","us-east-1d"]
  desired_capacity   = 2
  max_size           = 3
  min_size           = 1

  launch_template {
    id      = aws_launch_template.ec2_launch_template.id
    version = "$Latest"
  }
  target_group_arns = [ aws_lb_target_group.alb_target_group.arn ]
}

# Create a new ALB Target Group attachment
resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.launch_template_asg.id
  alb_target_group_arn   = aws_lb_target_group.alb_target_group.arn
}

resource "aws_cloudwatch_metric_alarm" "alarm_cpu_utilization" {
  alarm_name          = "alarm-cpu-utilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.launch_template_asg.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
}