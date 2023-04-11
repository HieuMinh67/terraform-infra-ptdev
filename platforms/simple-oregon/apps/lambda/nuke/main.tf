module "iam" {
  source      = "git::ssh://git@github.com/HieuMinh67/terraform-infra-skeleton.git//services/iam_for_lambda?ref=ptdev"
  environment = var.environment
}

module "lambda" {
  depends_on      = [module.iam]
  source          = "git::ssh://git@github.com/HieuMinh67/terraform-infra-skeleton.git//services/lambda_function_service?ref=ptdev"
  aws_region      = var.aws_region
  aws_account_id  = var.aws_account_ids.apps.lambda
  function_name   = "aws-nuke"
  handler         = "aws-nuke"
  project         = "aws-nuke"
  bounded_context = ""
  # subnet_ids
  # security_group_ids
  # file_name
  # lambda_logs_name
  # is_in_vpc
  # query_api_source_arn
  # mutation_api_source_arn
  service_name = "aws-nuke"
  # aws_account_id
  # organisation
  # aws_region
  # bean_region
  environment = var.environment
  # db_host
  # db_user
  # db_password
  # db_name
  # build_number
  is_http_api              = false
  authorizer_id            = ""
  apigateway_id            = ""
  apigateway_execution_arn = ""
  apigateway_name          = ""
  service_routes           = null
  target_account           = var.target_account
  lambda_runtime           = var.lambda_runtime
}
