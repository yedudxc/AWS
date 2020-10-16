provider "aws" {
  region = "${var.aws_region}"
}
data "aws_availability_zones" "available" {}

# VPC
resource "aws_vpc" "vpc" {
  cidr_block = "10.1.0.0/16"
}


# Route tables


resource "aws_default_route_table" "private" {
  default_route_table_id = "${aws_vpc.vpc.default_route_table_id}"

  tags {
    Name = "private"
  }
}



resource "aws_subnet" "rds1" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.cidrs["rds1"]}"
  map_public_ip_on_launch = false
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "rds1"
  }
}

resource "aws_subnet" "rds2" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.cidrs["rds2"]}"
  map_public_ip_on_launch = false
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"

  tags {
    Name = "rds2"
  }
}

resource "aws_subnet" "rds3" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.cidrs["rds3"]}"
  map_public_ip_on_launch = false
  availability_zone       = "${data.aws_availability_zones.available.names[2]}"

  tags {
    Name = "rds3"
  }
}

# Subnet Associations

resource "aws_db_subnet_group" "rds_subnetgroup" {
  name       = "rds_subnetgroup"
  subnet_ids = ["${aws_subnet.rds1.id}", "${aws_subnet.rds2.id}", "${aws_subnet.rds3.id}"]

  tags {
    Name = "rds_sng"
  }
}



#RDS Security Group
resource "aws_security_group" "RDS" {
  name        = "sg_rds"
  description = "Used for DB instances"
  vpc_id      = "${aws_vpc.vpc.id}"

# Only PostgreSQL in
ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["172.20.0.0/16"]
  }

}
#Password for DB

resource "random_string" "postgres_password" {
  length = 16
  special = false
}

locals {
  resource_name_prefix = "${var.namespace}-${var.resource_tag_name}"
}
#RDS


resource "aws_db_instance" "db" {
  identifier 		 = "${local.resource_name_prefix}-${var.identifier}"
  allocated_storage      = 10
  engine                 = "postgres"
  engine_version         = "9.6.9"
  instance_class         = "${var.db_instance_class}"
  name                   = "${var.dbname}"
  username               = "${var.dbuser}"
  password               = "${random_string.postgres_password.result}"
  db_subnet_group_name   = "${aws_db_subnet_group.rds_subnetgroup.name}"
  vpc_security_group_ids = ["${aws_security_group.RDS.id}"]
  skip_final_snapshot    = true
}


#-------OUTPUTS ------------

output "Database Name" {
  value = "${var.dbname}"
}

output "Database Hostname" {
  value = "${aws_db_instance.db.endpoint}"
}

output "Database Username" {
  value = "${var.dbuser}"
}

output "Database Password" {
  value = "${random_string.postgres_password.result}" 
  sensitive   = true
}

