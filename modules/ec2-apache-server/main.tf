data "aws_ami" "amazon-linux" {
  most_recent = true

  filter {
    name   = "image-id"
    values = var.ami_id
  }


  owners = ["137112412989"] # Canonical
}


resource "aws_security_group" "apache-server-security-group" {
  name        = "ec_security_group"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.default_vpc_id
  ingress {
    description = "SSH from Anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Http Request from Anywhere"
    from_port   = 80
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


resource "aws_instance" "web" {
  ami           = data.aws_ami.amazon-linux.id
  instance_type = "t2.micro"
  user_data_base64 = filebase64("${path.module}/scripts/ec2-user-data.sh")
  vpc_security_group_ids = ["${aws_security_group.apache-server-security-group.id}"]
  tags = merge({
    Name =var.instance_name,
    Creator = local.creator
  })
}