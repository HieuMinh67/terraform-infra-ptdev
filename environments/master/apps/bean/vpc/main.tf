module "skeleton" {
  source          = "../../../../../skeleton/apps/vpc"
  app_name        = local.app_name
  cidr_block      = var.cidr_block
  bounded_context = var.bounded_context
}
