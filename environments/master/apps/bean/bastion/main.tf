module "skeleton" {
  source          = "../../../../../skeleton/apps/bastion"
  subnet_id = data.terraform_remote_state.vpc.outputs.vpc_public_subnet_ids[0]
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
