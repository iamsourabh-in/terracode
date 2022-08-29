# module "ec2-apache-server" {
#   source = "./modules/ec2-apache-server"
#   instance_name = "my-first-apache-server"
#   ami_id = ["ami-06489866022e12a14"]
#   default_vpc_id = "vpc-01b2052d526f0a5f6"
# }



# module "ec2-asg-infra" {
#   source = "./modules/ec2-asg-infra"
#   ec_infra_ami_id = ["ami-06489866022e12a14"]
#   default_vpc_id = "vpc-01b2052d526f0a5f6"
# }


# module "random" {
#   source = "./modules/random-generator"
#   generate_uuid = true
# }




# resource "null_resource" "previous" {}

# resource "time_sleep" "wait_30_seconds" {
#   depends_on = [null_resource.previous]
#   create_duration = "12s"
# }

# # This resource will create (at least) 30 seconds after null_resource.previous
# resource "null_resource" "next" {
#   depends_on = [time_sleep.wait_30_seconds]
# }


# -------------------------------


# resource "aws_db_instance" "default" {
#   allocated_storage    = 10
#   engine               = "mysql"
#   engine_version       = "5.7"
#   instance_class       = "db.t2.micro"
#   name                 = "mydb"
#   username             = "foo"
#   password             = "foobarbaz"
#   parameter_group_name = "default.mysql5.7"
#   skip_final_snapshot  = true
# }

resource "kubernetes_namespace" "example" {
  metadata {
    name = "my-first-namespace"
  }
}