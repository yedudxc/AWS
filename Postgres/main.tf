provider "aws" {
  region = var.aws_region
}
data "aws_availability_zones" "available" {}
######
# VPC
######
#terraform version >= 12
############
resource "aws_vpc" "vpc_demo" {
  cidr_block           = var.cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = {
    Name = var.tags
  }

}
resource "aws_subnet" "private_1" {
  vpc_id                  = aws_vpc.vpc_demo.id
  cidr_block              = var.subnet1_cidr_block
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name = var.tags
  }
}

resource "aws_subnet" "private_2" {
  vpc_id                  = aws_vpc.vpc_demo.id
  cidr_block              = var.subnet2_cidr_block
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[1]

  tags = {
    Name = var.tags
  }
}

resource "aws_subnet" "private_3" {
  vpc_id                  = aws_vpc.vpc_demo.id
  cidr_block              = var.subnet3_cidr_block
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[2]

  tags = {
    Name = var.tags
  }
}
resource "aws_security_group" "db" {
  name        = "allow_SSH"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.vpc_demo.id

  ingress {
    # SSH Port 22 allowed from any IP
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_db_parameter_group" "default" {
  name   = "postgresql"
  family = var.parameter_group_family

  parameter {
    name  = "max_allowed_packet"
    value = "16777216"
  }
}

resource "aws_db_subnet_group" "default" {
  name       = "postgres-main"
  subnet_ids = [aws_subnet.private_1.id, aws_subnet.private_2.id, aws_subnet.private_3.id]

  tags = {
    Name = var.tags
  }
}



#Password for DB

resource "random_string" "postgres_password" {
  length = 16
  special = false
}

#RDS


resource "aws_db_instance" "db" {
  identifier 		 = var.identifier
  allocated_storage      = 10
  engine                 = "postgres"
  engine_version         = var.engine_version
  instance_class         = var.db_instance_class
  name                   = var.dbname
  username               = var.dbuser
  password               = random_string.postgres_password.result
  db_subnet_group_name   = aws_db_subnet_group.default.name
  vpc_security_group_ids = [aws_security_group.db.id]
  availability_zone      = aws_subnet.private_1.availability_zone
  skip_final_snapshot    = true
   tags = {
    Name = var.tags
  }

}

