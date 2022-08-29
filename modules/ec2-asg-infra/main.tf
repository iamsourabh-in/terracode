#AMI - Validates if the ID is correct , and will be used by ec2
data "aws_ami" "ec2_infra_ami" {
  most_recent = true
  filter {
    name   = "image-id"
    values = var.ec_infra_ami_id
  }
  owners = ["137112412989"] # Canonical
}

resource "aws_security_group" "ec2_infra_ssh_security_group" {
  name        = "ec2_infra_ssh_security_group"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.default_vpc_id
  ingress {
    description = "SSH from Anywhere"
    from_port   = 0
    to_port     = 22
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
}
# Security Group
resource "aws_security_group" "ec2_infra_alb_to_ec2_security_group" {
  name        = "ec2_infra_alb_to_ec2_security_group"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.default_vpc_id
  ingress {
    description = "Http Request from Anywhere"
    from_port   = 0
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = [aws_security_group.ec2_infra_alb_security_group.id]
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

resource "aws_security_group" "ec2_infra_alb_security_group" {
  name        = "ec2_infra_alb_security_group"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.default_vpc_id
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

resource "aws_key_pair" "ec2_infra_key_pair" {
  key_name   = "Terraform-test"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41 email@example.com"

}

# Launch Template
resource "aws_launch_template" "ec2_infra_launch_template" {
  name                                 = "ec_launch_template"
  image_id                             = data.aws_ami.ec2_infra_ami.id
  instance_type                        = "t2.micro"
  instance_initiated_shutdown_behavior = "terminate"
  vpc_security_group_ids               = [aws_security_group.ec2_infra_ssh_security_group.id, aws_security_group.ec2_infra_alb_to_ec2_security_group.id]
  key_name                             = aws_key_pair.ec2_infra_key_pair.key_name
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

# Target Group
resource "aws_lb_target_group" "ec_infra_alb_target_group" {
  name        = "alb-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.default_vpc_id
  target_type = "instance"
  tags = {
    Name       = "alb-target-group"
    AWSService = "TargetGroup"
  }
}

data "aws_subnet_ids" "ec_infra_aws_subnets" {
  vpc_id = var.default_vpc_id
}

resource "aws_lb" "ec2_infra_alb" {
  name                       = "ec2-infra-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.ec2_infra_alb_security_group.id]
  subnets                    = data.aws_subnet_ids.ec_infra_aws_subnets.ids
  enable_deletion_protection = false
  tags = {
    AWSService = "ALB"
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "ec2_infra_auto_scaling_group" {
  availability_zones = ["ap-south-1a","ap-south-1b","ap-south-1c"]
  desired_capacity   = 2
  max_size           = 3
  min_size           = 1

  launch_template {
    id      = aws_launch_template.ec2_infra_launch_template.id
    version = "$Latest"
  }
  target_group_arns = [ aws_lb_target_group.ec_infra_alb_target_group.arn ]
  
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.ec2_infra_alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ec_infra_alb_target_group.arn
  }
}


# Ec2 Area





# Create a new ALB Target Group attachment
resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.ec2_infra_auto_scaling_group.id
  alb_target_group_arn   = aws_lb_target_group.ec_infra_alb_target_group.arn
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
    AutoScalingGroupName = aws_autoscaling_group.ec2_infra_auto_scaling_group.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
}