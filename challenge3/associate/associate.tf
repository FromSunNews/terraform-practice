variable "sub_id" {
  type = string
}

variable "rtb_id" {
  type = string
}

# Gán Route Table cho Private Subnet
resource "aws_route_table_association" "association_tf" {
  subnet_id      = var.sub_id
  route_table_id = var.rtb_id
}
