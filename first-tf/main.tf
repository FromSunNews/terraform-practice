provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_vpc" "test_tf" {
  cidr_block = "192.168.0.0/16"

  tags = {
    Name = "Test TF"
  }
}
