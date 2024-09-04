variable "name" {
  description = "Name of any Object"
  type        = string
  default     = ""
}

variable "availability_zone_default" {
  description = "Availability Zone's default code"
  type        = string
  default     = "ap-northeast-2a"
}

variable "instance_ubuntu_default" {
  description = "default instance of Ubuntu 22.04"
  type        = string
  default     = "ami-056a29f2eddc40520"
}

output "availability_zone_default" {
  value = var.availability_zone_default
}

output "name" {
  value = var.name
}

output "instance_ubuntu_default" {
  value = var.instance_ubuntu_default
}
