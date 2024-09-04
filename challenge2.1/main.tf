provider "aws" {
  region = "ap-northeast-2"
}

# Tạo VPC
resource "aws_vpc" "vpc_tf" {
  cidr_block           = "10.11.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "VPC TF"
  }
}

# Tạo Internet Gateway
resource "aws_internet_gateway" "ig_tf" {
  vpc_id = aws_vpc.vpc_tf.id

  tags = {
    Name = "Internet Gateway TF"
  }
}

# Tạo Public Subnet
resource "aws_subnet" "public_subnet_tf" {
  vpc_id                  = aws_vpc.vpc_tf.id
  cidr_block              = "10.11.1.0/24"
  availability_zone       = "ap-northeast-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet TF"
  }
}

# Tạo Private Subnet
resource "aws_subnet" "private_subnet_tf" {
  vpc_id            = aws_vpc.vpc_tf.id
  cidr_block        = "10.11.2.0/24"
  availability_zone = "ap-northeast-2b"

  tags = {
    Name = "Private Subnet TF"
  }
}

# Tạo Route Table cho Public Subnet
resource "aws_route_table" "public_rtb_tf" {
  vpc_id = aws_vpc.vpc_tf.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig_tf.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

# Gán Route Table cho Public Subnet
resource "aws_route_table_association" "public_association_tf" {
  subnet_id      = aws_subnet.public_subnet_tf.id
  route_table_id = aws_route_table.public_rtb_tf.id
}

# Tạo Elastic IP cho NAT Gateway
resource "aws_eip" "nat_eip_tf" {
  tags = {
    Name = "NAT EIP"
  }
}

# Tạo NAT Gateway
resource "aws_nat_gateway" "nat_tf" {
  allocation_id = aws_eip.nat_eip_tf.id
  subnet_id     = aws_subnet.public_subnet_tf.id

  tags = {
    Name = "NAT Gateway"
  }
}

# Tạo Route Table cho Private Subnet
resource "aws_route_table" "private_rtb_tf" {
  vpc_id = aws_vpc.vpc_tf.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_tf.id
  }

  tags = {
    Name = "Private Route Table"
  }
}

# Gán Route Table cho Private Subnet
resource "aws_route_table_association" "private_association_tf" {
  subnet_id      = aws_subnet.private_subnet_tf.id
  route_table_id = aws_route_table.private_rtb_tf.id
}

# Tạo Security Group
resource "aws_security_group" "sg_tf" {
  vpc_id      = aws_vpc.vpc_tf.id
  name        = "SG TF"
  description = "Security Group for Terraform"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5124
    to_port     = 5124
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress mặc định cho phép tất cả
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SG TF"
  }
}

# Tạo Key Pair mới
resource "aws_key_pair" "my_key_pair" {
  key_name   = "key-pair-tf"
  public_key = file("~/.ssh/id_rsa.pub") # Đường dẫn đến public key của bạn
}

# Tạo Frontend Instance
resource "aws_instance" "frontend_instance" {
  ami                         = "ami-056a29f2eddc40520" # EC2 Ubuntu 22.04
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public_subnet_tf.id
  vpc_security_group_ids      = [aws_security_group.sg_tf.id]
  key_name                    = aws_key_pair.my_key_pair.key_name
  user_data                   = file("./user-data.sh")

  root_block_device {
    volume_size = 30
    volume_type = "gp2"
  }

  tags = {
    Name = "Frontend Instance"
  }
}

# Tạo Backend Instance
resource "aws_instance" "backend_instance" {
  ami                    = "ami-056a29f2eddc40520" # EC2 Ubuntu 22.04
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.private_subnet_tf.id
  vpc_security_group_ids = [aws_security_group.sg_tf.id]
  key_name               = aws_key_pair.my_key_pair.key_name

  root_block_device {
    volume_size = 30
    volume_type = "gp2"
  }

  tags = {
    Name = "Backend Instance"
  }
}
