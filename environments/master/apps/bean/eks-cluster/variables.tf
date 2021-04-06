variable "bounded_context" {
  type = string
}

variable "app_type" {}
variable "app_category" {}
variable "app_name" {}
variable "environment" {}
variable "organisation" {}
variable "tfe_token" {
  default = "NOT_REQUIRED"
}
variable "github_oauth_token" {
  default = "NOT_REQUIRED"
}

locals {
    app_name = "${var.environment}-${var.app_type}-${var.app_category}-${var.app_name}"
}