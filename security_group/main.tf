provider "aws" {}

resource "aws_instance" "instance_tf" {
  ami                    = "ami-056a29f2eddc40520" // ec2 ubuntu 22.04
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.sg_tf.id]
}

resource "aws_security_group" "sg_tf" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_security_group_rule" "allow_tls_ipv4" {
  type              = "ingress"
  security_group_id = aws_security_group.sg_tf.id
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] // Cho phép truy cập từ bất kỳ địa chỉ IP nào
}

resource "aws_security_group_rule" "allow_all_traffic_ipv4" {
  type              = "egress"
  security_group_id = aws_security_group.sg_tf.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"          # semantically equivalent to all ports
  cidr_blocks       = ["0.0.0.0/0"] // Cho phép tất cả lưu lượng đi ra ngoài
}
