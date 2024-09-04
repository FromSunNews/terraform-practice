variable "anywhere" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "db_pwd" {
  description = "password for db instance"
  type        = string
  sensitive   = true
}
