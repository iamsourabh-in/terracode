module "ec2-apache-server" {
  source = "./modules/ec2-apache-server"
  instance_name = "my-first-apache-server"
  ami_id = ["ami-06489866022e12a14"]
  default_vpc_id = "vpc-01b2052d526f0a5f6"
}

module "ec2-asg-infra" {
  source = "./modules/ec2-asg-infra"
  ec_infra_ami_id = ["ami-06489866022e12a14"]
  default_vpc_id = "vpc-01b2052d526f0a5f6"
}