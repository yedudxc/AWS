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
    from_port   = 3306
    to_port     = 3306
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
  name   = "mariadb"
  family = "mariadb10.2"

  parameter {
    name  = "max_allowed_packet"
    value = "16777216"
  }
}

resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = [aws_subnet.private_1.id, aws_subnet.private_2.id, aws_subnet.private_3.id]

  tags = {
    Name = var.tags
  }
}


resource "aws_db_instance" "mydb" {
  identifier             = "az-mf"
  allocated_storage      = 10
  storage_type           = "gp2"
  engine                 = "mariadb"
  engine_version         = "10.2.21"
  instance_class         = "db.t2.micro"
  name                   = "mydb"
  username               = "root"
  password               = "foobarbaz"
  parameter_group_name   = "mariadb"
  db_subnet_group_name   = aws_db_subnet_group.default.name
  vpc_security_group_ids = [aws_security_group.db.id]
  availability_zone      = aws_subnet.private_1.availability_zone
}

