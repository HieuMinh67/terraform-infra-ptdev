
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
}