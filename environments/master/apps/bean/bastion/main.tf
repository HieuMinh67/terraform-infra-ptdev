module "skeleton" {
  source          = "../../../../../skeleton/apps/bastion"
  subnet_id = data.terraform_remote_state.vpc.outputs.vpc_public_subnet_ids[0]
  app_name        = local.app_name
  bounded_context = var.bounded_context
  aws_secret_access_key = var.aws_secret_access_key
  aws_access_key_id = var.aws_access_key_id
  aws_region = var.aws_region
  private_key = var.private_key
  github_oauth_token = var.github_oauth_token
  tfe_token = var.tfe_token
  environment = var.environment
}
  
data "terraform_remote_state" "vpc" {
  backend = "remote"

  config = {
    organization = var.organisation
    workspaces = {
      name = "${var.environment}-${var.app_type}-${var.app_category}-vpc"
    }
  }
}
