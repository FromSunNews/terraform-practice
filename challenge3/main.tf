provider "aws" {}

module "variables" {
  source = "./variables"
}

module "vpc" {
  source = "./vpc"
}

module "igw" {
  source = "./igw"
  vpc_id = module.vpc.id
}

module "subnet" {
  source = "./subnet"
  vpc_id = module.vpc.id
}

module "eip" {
  source = "./eip"
}

module "natgw" {
  source    = "./natgw"
  eip_id    = module.eip.id
  pubsub_id = module.subnet.pub_id
}

module "rtb" {
  source   = "./rtb"
  natgw_id = aws_nat_gateway.nat_tf.id
  vpc_id   = module.vpc.id
  igw_id   = module.igw.id
}

# Gán Route Table cho Public Subnet
module "associate_pub" {
  source = "./associate"
  rtb_id = module.rtb.pub_id
  sub_id = module.subnet.pub_id
}

# Gán Route Table cho Private Subnet
module "associate_pub" {
  source = "./associate"
  rtb_id = module.rtb.priv_id
  sub_id = module.subnet.priv_id
}

module "sg" {
  source = "./sg"
  vpc_id = module.vpc.id
}

module "kp" {
  source = "./kp"
}

module "ec2" {
  source     = "./ec2"
  kp_keyname = module.kp.key_name
  privsub_id = module.subnet.priv_id
  pubsub_id  = module.subnet.pub_id
  sg_id      = module.sg.id
}
