terraform {
  required_version = ">= 0.12.0"
    backend "remote" {
          hostname = "app.terraform.io"

    organization = "BeanTraining"

    workspaces {
      name = "${var.environment}-${var.app_type}-${var.app_category}-${var.app_name}"
    }
  }
}