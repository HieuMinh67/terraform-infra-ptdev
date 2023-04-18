# mandatory vars from main ws
variable "aws_account_id" {
  type = string
}
variable "aws_account_ids" {}
variable "aws_access_key_id" {}
variable "aws_secret_access_key" {}
variable "tfe_token" {}
variable "github_oauth_token" {}

# child ws vars
variable "aws_region" {
  type    = string
  default = "us-west-2"
}
variable "suffix_name" {
  type    = string
  default = "aws-lambda"
}
variable "enable_versioning" {
  type    = bool
  default = false
}