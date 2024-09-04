variable "input_vpc_name" {
  type        = string
  description = "Set a name for vpc"
}

provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_vpc" "test_vpc_tf" {
  cidr_block = "192.188.0.0/16"

  tags = {
    Name = var.input_vpc_name
  }
}

output "output_vpc" {
  value = "The vpc ${aws_vpc.test_vpc_tf.id} has created"
}
