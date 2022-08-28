#AMI - Validates if the ID is correct , and will be used by ec2
data "aws_ami" "ec2_infra_ami" {
  most_recent = true
  filter {
    name   = "image-id"
    values = var.ec_infra_ami_id
  }
  owners = ["137112412989"] # Canonical
}

# Security Group
resource "aws_security_group" "ec2_infra_security_group" {
  name        = "ec_launch_template_security_group"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.default_vpc_id
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

# Launch Template
resource "aws_launch_template" "ec2_infra_launch_template" {
  name                                 = "ec_launch_template"
  image_id                             = data.aws_ami.ec2_infra_ami.id
  instance_type                        = "t2.micro"
  instance_initiated_shutdown_behavior = "terminate"
  vpc_security_group_ids               = [aws_security_group.ec2_infra_security_group.id]
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

resource "aws_lb" "ec2_infra_alb" {
  name                       = "my-frontend-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.ec2_infra_security_group.id]
  subnets                    = [for subnet in var.aws_subnets : subnet]
  enable_deletion_protection = false
  tags = {
    AWSService = "ALB"
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "ec2_infra_auto_scaling_group" {
  availability_zones = ["us-east-1a","us-east-1b","us-east-1c","us-east-1d"]
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