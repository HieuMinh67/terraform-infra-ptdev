module "iam" {
  source      = "git::ssh://git@github.com/HieuMinh67/terraform-infra-skeleton.git//services/iam_for_lambda"
  environment = var.environment
}

module "lambda" {
  depends_on               = [module.iam]
  source                   = "git::ssh://git@github.com/HieuMinh67/terraform-infra-skeleton.git//services/lambda_function_service"
  aws_region               = var.aws_region
  aws_account_id           = var.aws_account_ids.apps.lambda
  function_name            = var.function_name
  handler                  = "aws-nuke"
  project                  = var.project
  bounded_context          = var.aws_account_ids.apps.lambda
  service_name             = var.service_name
  environment              = var.environment
  is_http_api              = false
  authorizer_id            = ""
  apigateway_id            = ""
  apigateway_execution_arn = ""
  apigateway_name          = ""
  service_routes           = null
  target_account           = var.target_account
  lambda_runtime           = var.lambda_runtime
  lambda_timeout           = var.lambda_timeout
  s3_object_key            = var.s3_object_key

  lambda_schedule_expression = var.lambda_schedule_expression
}
