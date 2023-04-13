variable "cidr_block" {}
variable "public_subnet_cidr_blocks" {}
variable "private_subnet_cidr_blocks" {}
variable "nat_instance_private_ip" {}

variable "bounded_context" {}

variable "app_type" {}
variable "app_category" {}
variable "app_name" {}
variable "platform" {}
variable "environment" {}
variable "organisation" {}

locals {
  app_name = "${var.environment}-${var.platform}-${var.app_type}-${var.app_category}-${var.app_name}"
}

variable "aws_region" {}
variable "aws_access_key_id" {}
variable "aws_secret_access_key" {}
variable "kops_vpc_id" {}
