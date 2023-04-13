
variable "aws_region" {
  default = "us-west-2"
}
variable "aws_access_key_id" {}
variable "aws_secret_access_key" {}
variable "environment" {}
variable "organisation" {}
variable "aws_account_ids" {}
variable "target_account" {
  type = map(string)
  default = {
    "account_id"   = ""
    "iam_username" = ""
    "access_key"   = ""
    "secret_key"   = ""
  }
}
variable "lambda_runtime" {
  type    = string
  default = "provided.al2"
}
variable "s3_object_key" {
  type        = string
  description = "{aws_account_id}-{aws_region}-aws-lambda + object key = s3 path of zip file used for building lambda function"
}

variable "lambda_timeout" {
  type    = number
  default = 12
}