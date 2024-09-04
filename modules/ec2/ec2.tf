# ec2.tf
variable "ec2_name" {
  type = string
}

resource "aws_instance" "instance_tf" {
  ami           = "ami-056a29f2eddc40520" // ec2 ubuntu 22.04
  instance_type = "t2.micro"

  tags = {
    Name = var.ec2_name
  }
}

output "output_ec2_id" {
  value = aws_instance.instance_tf.id
}
