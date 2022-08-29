resource "random_uuid" "uuid" {
  count = local.generate
}

resource "random_integer" "priority" {
  min = 1
  max = 50000
  keepers = {

  }
}