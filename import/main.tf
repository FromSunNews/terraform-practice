provider "aws" {
}

resource "aws_vpc" "test_tf" {
  cidr_block = "192.168.0.0/16"

  tags = {
    Name = "Test TF"
  }
}

resource "aws_vpc" "test_tf2" {
  cidr_block = "198.167.0.0/16"

  tags = {
    Name = "Test TF"
  }
}
