/**
  tfe_variables.tf
- aws_region
*/
  
# https://learn.hashicorp.com/tutorials/terraform/lambda-api-gateway?in=terraform/aws

provider "aws" {
   region = var.aws_region
}

