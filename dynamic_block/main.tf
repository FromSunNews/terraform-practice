provider "aws" {}

variable "ingress_rules" {
  type = list(object({
    port        = number
    description = string
    cidr_blocks = list(string)
    protocol    = string
  }))
  default = [
    {
      cidr_blocks = ["0.0.0.0/0"]
      description = "access to http"
      port        = 80
      protocol    = "tcp"
    },
    {
      cidr_blocks = ["0.0.0.0/0"]
      description = "access to https"
      port        = 443
      protocol    = "tcp"
    },
    {
      cidr_blocks = ["0.0.0.0/0"]
      description = "access to mysql"
      port        = 3306
      protocol    = "tcp"
    },
    {
      cidr_blocks = ["0.0.0.0/0"]
      description = "access to website"
      port        = 8080
      protocol    = "tcp"
    }
  ]
}

resource "aws_instance" "instance_tf" {
  ami                    = "ami-056a29f2eddc40520" // ec2 ubuntu 22.04
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.sg_tf.id]
}

resource "aws_security_group" "sg_tf" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"

  tags = {
    Name = "allow_tls"
  }

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
}
