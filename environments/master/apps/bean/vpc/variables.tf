variable "cidr_block" {
  type = string
}

variable "bounded_context" {
  type = string
}

variable "app_type" {}
variable "app_category" {}
variable "app_name" {}
locals {
    app_name = "${var.environment}-${var.app_type}-${var.app_category}-${var.app_name}"
}