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
