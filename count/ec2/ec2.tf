variable "ins_names" {
  type = list(string)
}

variable "ins_types" {
  type = list(string)
}

variable "ins_ami" {
  type = list(string)
}

resource "aws_instance" "ins_tf" {
  ami           = var.ins_ami[count.index]
  instance_type = var.ins_types[count.index]
  count         = length(var.ins_names)
  tags = {
    Name = var.ins_names[count.index]
  }

}

output "private_ips" {
  value = aws_instance.ins_tf.*.private_ip
}
