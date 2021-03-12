/**
  tfe_variables.tf
- aws_region
*/
  
# https://learn.hashicorp.com/tutorials/terraform/lambda-api-gateway?in=terraform/aws
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
   region = var.aws_region
}

