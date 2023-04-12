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
  service_name = "aws-nuke"
  environment = var.environment
  is_http_api              = false
  authorizer_id            = ""
  apigateway_id            = ""
  apigateway_execution_arn = ""
  apigateway_name          = ""
  service_routes           = null
  target_account           = var.target_account
  lambda_runtime           = var.lambda_runtime
  s3_object_key = var.s3_object_key
}
