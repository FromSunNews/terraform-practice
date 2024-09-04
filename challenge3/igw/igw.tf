variable "vpc_id" {
  type = string
}

resource "aws_internet_gateway" "ig_tf" {
  vpc_id = var.vpc_id

  tags = {
    Name = "Internet Gateway TF"
  }
}
output "id" {
  value = aws_internet_gateway.ig_tf.id
}
