provider "aws" {}

resource "aws_instance" "instance_tf" {
  ami           = "ami-056a29f2eddc40520" // ec2 ubuntu 22.04
  instance_type = "t2.micro"
}

resource "aws_eip" "eip_tf" {
  instance = aws_instance.instance_tf.id
}

output "eip_output" {
  value = aws_eip.eip_tf.public_ip
}
