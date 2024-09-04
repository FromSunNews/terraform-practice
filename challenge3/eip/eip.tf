# Tạo Elastic IP cho NAT Gateway
resource "aws_eip" "nat_eip_tf" {
  tags = {
    Name = "NAT EIP"
  }
}

output "id" {
  value = aws_eip.nat_eip_tf.id
}
