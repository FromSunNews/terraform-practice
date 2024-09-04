provider "aws" {}

data "aws_availability_zones" "azs" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.13.0"

  name                 = "education"
  cidr                 = "10.11.0.0/16"
  azs                  = data.aws_availability_zones.azs.names
  public_subnets       = ["10.11.1.0/24", "10.11.2.0/24", "10.11.3.0/24"]
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_db_subnet_group" "dbsubgr_tf" {
  name       = "dbsubgr_tf"
  subnet_ids = module.vpc.public_subnets

  tags = {
    Name = "Db Subnet Group TF"
  }
}

resource "aws_security_group" "sg_tf" {
  name   = "sg_tf"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 3600
    to_port     = 3600
    description = "Access to mysql"
    protocol    = "tcp"
    cidr_blocks = var.anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    description = "Access to anywhere"
    protocol    = "-1"
    cidr_blocks = var.anywhere
  }

  tags = {
    Name = "SG TF"
  }
}

resource "aws_db_parameter_group" "prams_db" {
  name   = "pramsdbtf"
  family = "mysql8.0"
  parameter {
    name  = "max_connections"
    value = "200"
  }
}

resource "aws_db_instance" "db_ins_tf" {
  identifier             = "test"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "mysql"
  engine_version         = "8.0.39"
  username               = "test"
  password               = var.db_pwd
  db_subnet_group_name   = aws_db_subnet_group.dbsubgr_tf.name
  vpc_security_group_ids = [aws_security_group.sg_tf.id]
  parameter_group_name   = aws_db_parameter_group.prams_db.name
  publicly_accessible    = true
  skip_final_snapshot    = true
}
