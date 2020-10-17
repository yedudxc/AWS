variable "aws_region"{
   default    = "us-east-1"
}
variable "cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = "10.0.0.0/16"
}
variable "enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Should be true to enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = string
}
variable "subnet1_cidr_block" {
  description = "The CIDR block for the private1 subnet"
  type        = string
  default     = "10.0.1.0/24"
}
variable "subnet2_cidr_block" {
  description = "The CIDR block for the private3 subnet"
  type        = string
  default     = "10.0.2.0/24"
}
variable "subnet3_cidr_block" {
  description = "The CIDR block for the private3 subnet"
  type        = string
  default     = "10.0.3.0/24"
}
variable "identifier" {
   description = "Company Name"
   default    = "allianz"
}
variable "engine_version" {
 description = "engine_version"
  default     = "12.2"
}
variable "parameter_group_family" {
  description = "parameter_group_family"
  default    = "postgres12"
}
variable "db_instance_class" {
  description = "db_instance_class"
  default    = "db.t2.micro"
}
variable "dbname" {
  description = "dbname"
  default    = "testDB"
}
variable "dbuser" {
  description = "dbuser"
  default    = "testDBadmin"
}
