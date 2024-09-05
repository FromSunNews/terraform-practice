provider "aws" {}

resource "aws_instance" "instance_db_tf" {
  ami           = "ami-056a29f2eddc40520" // ec2 ubuntu 22.04
  instance_type = "t2.micro"
}

resource "aws_instance" "instance_web_tf" {
  ami           = "ami-056a29f2eddc40520" // ec2 ubuntu 22.04
  instance_type = "t2.micro"
  depends_on    = [aws_instance.instance_db_tf]
}
