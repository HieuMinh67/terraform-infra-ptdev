locals {
  shared_environment_variables = {
  }
  shared_terraform_variables = {
    environment = var.environment,
    aws_region  = var.aws_region
  }
}
variable "private_key" {}
variable "aws_region" {
  type    = string
  default = "us-west-2"
}
variable "aws_access_key_id" {}
variable "aws_secret_access_key" {}
variable "organisation" {
  type = string
  default = "BeanTraining"
}
variable "aws_account_ids" {
  type = map(string)
}
resource "tfe_variable" "this-environment" {
  # We'll need one tfe_variable instance for each
  # combination of workspace and environment variable,
  # so this one has a more complicated for_each expression.
  for_each = {
    for pair in setproduct(var.workspaces, keys(local.shared_environment_variables)) : "${var.environment}-${pair[0].app_type}-${pair[0].app_category}-${pair[0].app_name}/${pair[1]}" => {
      workspace_name = "${var.environment}-${pair[0].app_type}-${pair[0].app_category}-${pair[0].app_name}"
      workspace_id   = tfe_workspace.this["${var.environment}-${pair[0].app_type}-${pair[0].app_category}-${pair[0].app_name}"].id
      name           = pair[1]
      value          = local.shared_environment_variables[pair[1]]
    }
  }

  workspace_id = each.value.workspace_id

  category  = "env"
  key       = each.value.name
  value     = each.value.value
  sensitive = false
}
resource "tfe_variable" "this-terraform" {
  # We'll need one tfe_variable instance for each
  # combination of workspace and terraform variable,
  # so this one has a more complicated for_each expression.
  for_each = {
    for pair in setproduct(var.workspaces, keys(local.shared_terraform_variables)) : "${var.environment}-${pair[0].app_type}-${pair[0].app_category}-${pair[0].app_name}/${pair[1]}" => {
      workspace_name = "${var.environment}-${pair[0].app_type}-${pair[0].app_category}-${pair[0].app_name}"
      workspace_id   = tfe_workspace.this["${var.environment}-${pair[0].app_type}-${pair[0].app_category}-${pair[0].app_name}"].id
      name           = pair[1]
      value          = local.shared_terraform_variables[pair[1]]
    }
  }

  workspace_id = each.value.workspace_id

  category  = "terraform"
  key       = each.value.name
  value     = each.value.value
  sensitive = false
}
resource "tfe_variable" "this-environment-aws_access_key_id" {
  count = length(var.workspaces)

  workspace_id = tfe_workspace.this["${var.environment}-${var.workspaces[count.index].app_type}-${var.workspaces[count.index].app_category}-${var.workspaces[count.index].app_name}"].id

  category  = "terraform"
  key       = "AWS_ACCESS_KEY_ID"
  value     = var.aws_access_key_id
  sensitive = true
}

resource "tfe_variable" "this-environment-aws_secret_access_key" {
  count = length(var.workspaces)

  workspace_id = tfe_workspace.this["${var.environment}-${var.workspaces[count.index].app_type}-${var.workspaces[count.index].app_category}-${var.workspaces[count.index].app_name}"].id

  category  = "terraform"
  key       = "AWS_SECRET_ACCESS_KEY"
  value     = var.aws_secret_access_key
  sensitive = true
}

resource "tfe_variable" "this-terraform-organisation" {
  count = length(var.workspaces)

  workspace_id = tfe_workspace.this["${var.environment}-${var.workspaces[count.index].app_type}-${var.workspaces[count.index].app_category}-${var.workspaces[count.index].app_name}"].id

  category  = "terraform"
  key       = "organisation"
  value     = var.organisation
  sensitive = true
}

resource "tfe_variable" "this-terraform-private_key" {
  count = length(var.workspaces)

  workspace_id = tfe_workspace.this["${var.environment}-${var.workspaces[count.index].app_type}-${var.workspaces[count.index].app_category}-${var.workspaces[count.index].app_name}"].id

  category  = "terraform"
  key       = "private_key"
  value     = var.private_key
  sensitive = true
}

# resource "tfe_variable" "this-environment-aws_account_ids" {
#   count = length(var.workspaces)

#   workspace_id = tfe_workspace.this["${var.environment}-${var.workspaces[count.index].app_type}-${var.workspaces[count.index].app_category}-${var.workspaces[count.index].app_name}"].id

#   category  = "terraform"
#   key       = "aws_account_ids"
#   value     = "{apps = ${var.aws_account_ids.apps}}"
#   sensitive = true
#   hcl       = true
# }

