variable "aws_region" {}
variable "vpc_cidr" {}
variable "db_instance_class" {}
variable "namespace" {}
variable "identifier" {}
variable "resource_tag_name" {}
variable "dbname" {}
variable "dbuser" {}
variable "cidrs" {
  type = "map"
}
