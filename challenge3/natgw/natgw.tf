variable "eip_id" {
  type = string
}

variable "pubsub_id" {
  type = string
}

# Tạo NAT Gateway
resource "aws_nat_gateway" "nat_tf" {
  allocation_id = var.eip_id
  subnet_id     = var.pubsub_id

  tags = {
    Name = "NAT Gateway"
  }
}

output "id" {
  value = aws_nat_gateway.nat_tf.id
}
