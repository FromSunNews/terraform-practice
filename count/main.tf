provider "aws" {

}

module "instances_ec2" {
  source    = "./ec2"
  ins_aim   = ["ami-056a29f2eddc40520", "ami-056a29f2eddc40520", "ami-056a29f2eddc40520"]
  ins_names = ["EC2 TF 1", "EC2 TF 2", "EC2 TF 3"]
  ins_types = ["t2.micro", "t2.small", "t3.micro"]
}

output "priv_ips" {
  value = module.instances_ec2.private_ips
}
