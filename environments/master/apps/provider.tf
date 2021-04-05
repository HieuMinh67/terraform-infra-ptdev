terraform {
}

provider "aws" {
  version = "3.28.0"
  region = var.aws_region
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}

variable "aws_region" {
  type    = string
  default = "us-west-2"
}
variable "aws_access_key_id" {}
variable "aws_secret_access_key" {}

# TODO - improve
variable "private_key" {}