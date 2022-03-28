variable "user_groups" {
  type    = list(string)
  default = ["dev", "qa"]
}

variable "users" {
  type = list(object({
    name  = string
    group = string
  }))
  default = [
    {
      name  = "srustag_dev"
      group = "qa"
    },
    {
      name  = "srustag_qa"
      group = "qa"
    }
  ]
}


variable "aws_budget" {
  type = object({
    name   = string
    amount = number,
    alert_email = list(string)
  })
  default = {
    name   = "AWS Initial Budget"
    amount = 5,
    alert_email = ["devcache.in@gmail.com"]
  }
}

variable "aws_subnets" {
  type = list(string)
  default = [ "subnet-0a34eb5e71a6cc12a","subnet-0bf29c71441b0bd60","subnet-0e670b2abaedd810e", "subnet-086e62600ebda72b8"]
}

variable "default_eu1_vpc_id" {
  type = string
  default = "vpc-01a64cf9cdf93488d"  
}