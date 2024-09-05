provider "aws" {

}

resource "aws_vpc" "vpc" {
  cidr_block = "10.18.0.0./16"
}
