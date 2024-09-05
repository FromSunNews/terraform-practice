provider "aws" {

}

# module "instances_ec2" {
#   source    = "./ec2"
#   ins_ami   = ["ami-056a29f2eddc40520", "ami-056a29f2eddc40520", "ami-056a29f2eddc40520"]
#   ins_names = ["EC2 TF 1", "EC2 TF 2", "EC2 TF 3"]
#   ins_types = ["t2.micro", "t2.small", "t3.micro"]
# }

# or

module "instances_ec2" {
  source = "./ec2"

  for_each = {
    "EC2_TF_1" = {
      ami  = "ami-056a29f2eddc40520"
      type = "t2.micro"
    }
    "EC2_TF_2" = {
      ami  = "ami-056a29f2eddc40520"
      type = "t2.small"
    }
    "EC2_TF_3" = {
      ami  = "ami-056a29f2eddc40520"
      type = "t3.micro"
    }
  }

  ins_ami   = each.value.ami
  ins_names = each.key
  ins_types = each.value.type
}

output "priv_ips" {
  value = module.instances_ec2.private_ips
}
