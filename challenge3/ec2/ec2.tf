module "variables" {
  source = "../variables"
}
variable "pubsub_id" {
  type = string
}

variable "privsub_id" {
  type = string
}

variable "sg_id" {
  type = string
}

variable "kp_keyname" {
  type = string
}

# Tạo Frontend Instance
resource "aws_instance" "frontend_instance" {
  ami                         = module.variables.instance_ubuntu_default
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id                   = var.pubsub_id
  vpc_security_group_ids      = [var.sg_id]
  key_name                    = var.kp_keyname
  user_data                   = file("./data/user-data.sh")

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
  ami                    = module.variables.instance_ubuntu_default
  instance_type          = "t3.micro"
  subnet_id              = var.privsub_id
  vpc_security_group_ids = [var.sg_id]
  key_name               = var.kp_keyname

  root_block_device {
    volume_size = 30
    volume_type = "gp2"
  }

  tags = {
    Name = "Backend Instance"
  }
}

