
variable "ec_infra_ami_id" {
  type  = list(string)
  default = ["ami-06489866022e12a14"]
}

variable "aws_subnets" {
  type = list(string)
  default = [ "subnet-0a34eb5e71a6cc12a","subnet-0bf29c71441b0bd60","subnet-0e670b2abaedd810e", "subnet-086e62600ebda72b8"]
}

variable "default_vpc_id" {
  type = string
  default = "vpc-01a64cf9cdf93488d"  
}

variable "aws_region"{
  type = string
  default = "ap-south-1"
}