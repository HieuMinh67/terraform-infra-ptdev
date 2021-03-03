module "vpc" {
  source     = "../../../modules/aws-vpc"
  app_name   = var.app_name
  cidr_block = var.cidr_block
}
