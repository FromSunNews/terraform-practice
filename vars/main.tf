provider "aws" {}

variable "number_instances" {
  type = number
}


resource "aws_instance" "instance_tf" {
  ami           = "ami-056a29f2eddc40520" // ec2 ubuntu 22.04
  instance_type = "t2.micro"
  count         = var.number_instances
}
