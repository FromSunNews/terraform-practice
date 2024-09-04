variable "vpc_id" {
  type = string
}

resource "aws_security_group" "sg_tf" {
  vpc_id      = var.vpc_id
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

output "id" {
  value = aws_security_group.sg_tf.id
}
