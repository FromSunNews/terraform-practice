# - hãy tạo lần lượt theo yêu cầu sau đây:
# - tạo một vpc 10.11.0.0
# - tạo 2 subnet private avf public ở region ap-northeast-2 a và b
# - tạo sg egress mặc định ingress cho phép tpc cổng 22 (ssh), 3306(mysql), 8080 (fe), 5124(be)
# - tạo 2 instance một cái là t2.micro(fe), cái còn lại là t3.micro(be) và gán cho nó 2 EIP
# - chạy script để khởi tạo website 

provider "aws" {}

# tạo một vpc 10.11.0.0
resource "aws_vpc" "vpc_tf" {
  cidr_block = "10.11.0.0/16"

  tags = {
    Name = "VPC TF"
  }
}

# tạo Internet Getway
resource "aws_internet_gateway" "ig_tf" {
  vpc_id = aws_vpc.vpc_tf.id

  tags = {
    Name = "Internet Gateway TF"
  }
}

# tạo 2 subnet private và public ở region ap-northeast-2 a và b
resource "aws_subnet" "public_subnet_tf" {
  vpc_id                  = aws_vpc.vpc_tf.id
  cidr_block              = "10.11.1.0/24"
  availability_zone       = "ap-northeast-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet TF"
  }
}

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

# tạo sg egress mặc định ingress cho phép tpc cổng 22 (ssh), 3306(mysql), 8080 (fe), 5124(be)
variable "anywhere" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "tcp" {
  type    = string
  default = "tcp"
}

variable "ingress" {
  type = list(object({
    port        = number,
    description = string
  }))

  default = [
    {
      port        = 22,
      description = "ssh from anywhere"
    },
    {
      port        = 3306,
      description = "access from anywhere to mysql"
    },
    {
      port        = 8080,
      description = "access from anywhere to frontend"
    },
    {
      port        = 5124,
      description = "access from anywhere to backend"
    },
  ]
}

resource "aws_security_group" "sg_tf" {
  name        = "SG TF"
  description = "Security Group for Terraform"

  dynamic "ingress" {
    for_each = var.ingress
    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = var.tcp
      cidr_blocks = var.anywhere
    }
  }

  # engress default nên không cần khai báo
  tags = {
    Name = "SG TF"
  }
}

# tạo 2 instance một cái là t2.micro(fe), cái còn lại là t3.micro(be) và gán cho nó 2 EIP

resource "aws_instance" "frontend_instance" {
  ami                         = "ami-056a29f2eddc40520" // ec2 ubuntu 22.04
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public_subnet_tf.id
  vpc_security_group_ids      = [aws_security_group.sg_tf.id]

  user_data = file("./user-data.sh")

  root_block_device {
    volume_size = 30
    volume_type = "gp2"
  }

  tags = {
    Name = "Frontend Instance"
  }
}

resource "aws_instance" "backend_instance" {
  ami                    = "ami-056a29f2eddc40520" // ec2 ubuntu 22.04
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.private_subnet_tf.id
  vpc_security_group_ids = [aws_security_group.sg_tf.id]

  root_block_device {
    volume_size = 30
    volume_type = "gp2"
  }

  tags = {
    Name = "Backend Instance"
  }
}
