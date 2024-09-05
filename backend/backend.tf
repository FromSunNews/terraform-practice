terraform {
  backend "s3" {
    key        = "terraform/tfstate.tfstate"
    bucket     = "tf_fsn_s3"
    region     = "ap-northeast-2"
    access_key = "*****************"
    secret_key = "*****************"
  }
}
