module "s3_bucket" {
  source            = "git::ssh://git@github.com/BeanTraining/terraform-infra-skeleton.git//s3/bucket"
  aws_account_id    = var.aws_account_id
  enable_versioning = var.enable_versioning
}
