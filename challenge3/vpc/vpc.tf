# Tạo VPC
resource "aws_vpc" "vpc_tf" {
  cidr_block           = "10.11.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "VPC TF"
  }
}

output "id" {
  value = aws_vpc.vpc_tf.id
}
