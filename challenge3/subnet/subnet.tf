module "variables" {
  source = "../variables"
}

variable "vpc_id" {
  type = string
}

# Tạo Public Subnet
resource "aws_subnet" "public_subnet_tf" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.11.1.0/24"
  availability_zone       = module.variables.availability_zone_default
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet TF"
  }
}

# Tạo Private Subnet
resource "aws_subnet" "private_subnet_tf" {
  vpc_id            = var.vpc_id
  cidr_block        = "10.11.2.0/24"
  availability_zone = module.variables.availability_zone_default

  tags = {
    Name = "Private Subnet TF"
  }
}

output "pub_id" {
  value = aws_subnet.public_subnet_tf.id
}

output "priv_id" {
  value = aws_subnet.private_subnet_tf.id
}
