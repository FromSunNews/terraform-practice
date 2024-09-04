# Tạo Key Pair mới
resource "aws_key_pair" "my_key_pair" {
  key_name   = "key-pair-tf"
  public_key = file("~/.ssh/id_rsa.pub") # Đường dẫn đến public key của bạn
}

output "key_name" {
  value = aws_key_pair.my_key_pair.key_name
}
