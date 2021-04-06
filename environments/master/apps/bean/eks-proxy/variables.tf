
# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------
variable "private_key" {
  type = string
  }

variable "aws_secret_access_key" {
  type = string
  default = "aws_secret_access_key"
  }
variable "aws_access_key_id" {
  type = string
  }
  
# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------
variable "ssh_port" {
  description = "The port the EC2 Instance should listen on for SSH requests."
  type        = number
  default     = 22
}

variable "ssh_user" {
  description = "SSH user name to use for remote exec connections,"
  type        = string
  default     = "centos"
}

variable "environment" {}
variable "app_type" {}
variable "app_category" {}
variable "app_name" {}
variable "tfe_token" {
  default = "NOT_REQUIRED"
}
variable "github_oauth_token" {
  default = "NOT_REQUIRED"
}

locals {
    app_name = "${var.environment}-${var.app_type}-${var.app_category}-${var.app_name}"
    bastion_name = "${var.environment}-${var.app_type}-${var.app_category}-bastion"
}