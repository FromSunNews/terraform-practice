# main.tf
provider "aws" {}

module "ec2_module" {
  source   = "./ec2"
  ec2_name = "Ec2 From Module"
}

output "output_module_ec2_id" {
  description = "Id of Instance is :"
  value       = module.ec2_module.output_ec2_id
}
