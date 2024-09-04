variable "vpcname" {
  type    = string
  default = "myvpc"
}

variable "sshport" {
  type    = number
  default = 22
}

variable "enabled" {
  default = true
}

variable "mylist" {
  type    = list(string)
  default = ["Value1", "Value2"]
}

variable "myMap" {
  type = map(any)
  default = {
    Key1 = "Value1"
    Key2 = "Value2"
  }
}

variable "inputname" {
  type        = string
  description = "Set the of VPC"
}

variable "mytuple" {
  type    = tuple([string, number, string])
  default = ["cat", 1, "dog"]
}

variable "myobject" {
  type = object({
    name = string,
    port = list(number)
  })
  default = {
    name = "T3",
    port = [22, 25, 80]
  }
}


provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_vpc" "test_tf" {
  cidr_block = "10.168.0.0/16"

  tags = {
    Name = var.inputname
  }
}

output "myoutput_vpc" {
  value = aws_vpc.test_tf.id
}
