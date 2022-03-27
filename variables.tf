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
