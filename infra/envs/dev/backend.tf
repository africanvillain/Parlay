terraform {
  backend "s3" {
    bucket  = "parlay-analyzer-tf-state"
    key     = "envs/dev/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
