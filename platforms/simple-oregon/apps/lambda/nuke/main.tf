module "iam" {
  source = "git::ssh://git@github.com/HieuMinh67/terraform-infra-skeleton.git//services/iam_for_lambda?ref=ptdev"
  environment    = var.environment
}

module "lambda" {
  source                = "git::ssh://git@github.com/HieuMinh67/terraform-infra-skeleton.git//services/lambda_function_service?ref=ptdev"
  aws_region            = var.aws_region
  aws_access_key_id     = var.aws_access_key_id
  aws_secret_access_key = var.aws_secret_access_key
  aws_account_id        = var.aws_account_ids.apps.lambda
  function_name         = "aws-nuke"
  handler               = "aws-nuke"
  # project = 
  # bounded_context
  # subnet_ids
  # security_group_ids
  # file_name
  # lambda_logs_name
  # is_in_vpc
  # query_api_source_arn
  # mutation_api_source_arn
  # service_name
  # aws_account_id
  # organisation
  # aws_region
  # bean_region
  # environment
  # db_host
  # db_user
  # db_password
  # db_name
  # build_number
}
