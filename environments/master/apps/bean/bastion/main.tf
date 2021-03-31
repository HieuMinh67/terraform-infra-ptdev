locals {
    app_name = "${var.environment}-${var.app_type}-${var.app_category}-${var.app_namey}"
}

module "skeleton" {
  source          = "../../../../../skeleton/apps/bastion"
  subnet_id = data.terraform_remote_state.vpc.outputs.subnet_id
  app_name        = local.app_name
  bounded_context = var.bounded_context
}
  
data "terraform_remote_state" "vpc" {
  backend = "remote"

  config = {
    organization = "BeanTraining"
    workspaces = {
      name = "${var.environment}-${var.app_type}-${var.app_category}-vpc"
    }
  }
}
