variable "vpc_id" {
  type = string
}

variable "anywhere" {
  type    = string
  default = "0.0.0.0/0"
}

variable "natgw_id" {
  type = string
}

variable "igw_id" {
  type = string
}

# Tạo Route Table cho Public Subnet
resource "aws_route_table" "public_rtb_tf" {
  vpc_id = var.vpc_id

  route {
    cidr_block = var.anywhere
    gateway_id = var.igw_id
  }

  tags = {
    Name = "Public Route Table"
  }
}

# Tạo Route Table cho Private Subnet
resource "aws_route_table" "private_rtb_tf" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = var.anywhere
    nat_gateway_id = var.natgw_id
  }

  tags = {
    Name = "Private Route Table"
  }
}

output "pub_id" {
  value = aws_route_table.public_rtb_tf.id
}

output "priv_id" {
  value = aws_route_table.private_rtb_tf.id
}
