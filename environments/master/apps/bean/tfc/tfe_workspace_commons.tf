

data "tfe_workspace" "this-tfc" {
  name         = "${var.environment}-terraform-cloud"
  organization = "BeanTraining"
}
variable "workspaces" {
  type = list(object({
    base_directory   = string
    app_type         = string
    app_category     = string
    app_name         = string
    auto_apply       = bool
    depends_on       = string
    trigger_prefixes = list(string)
  }))
}

variable "notification_endpoint" {
  type = string
  default = "https://bq9qinvfld.execute-api.us-west-2.amazonaws.com/test?"
 }
 
variable "api_key" {
  type = string
  default = "123456789"
}

variable "environment" {
  type    = string
  default = "dev-sg"
}

resource "tfe_oauth_client" "this-github" {
  organization     = "BeanTraining"
  api_url          = "https://api.github.com"
  http_url         = "https://github.com"
  oauth_token      = var.github_oauth_token
  service_provider = "github"
}

resource "tfe_run_trigger" "this" {
  for_each      = { for ws in var.workspaces : "${var.environment}-${ws.app_type}-${ws.app_category}-${ws.app_name}" => ws }
  workspace_id  = tfe_workspace.this["${var.environment}-${each.value.app_type}-${each.value.app_category}-${each.value.app_name}"].id
  sourceable_id = each.value.depends_on == "" ? data.tfe_workspace.this-tfc.id : tfe_workspace.this["${var.environment}-${each.value.depends_on}"].id
}
  
resource "tfe_notification_configuration" "this-auto-approver" {
  for_each         = { for ws in var.workspaces : "this-auto-approver-${var.environment}-${ws.app_type}-${ws.app_category}-${ws.app_name}" => ws }
  name             = "this-auto-approver-${var.environment}-${each.value.app_type}-${each.value.app_category}-${each.value.app_name}"
  enabled          = true
  destination_type = "generic"
  triggers         = ["run:needs_attention"]
  url              = "${var.notification_endpoint}"
  token            = var.api_key
  workspace_id     = tfe_workspace.this["${var.environment}-${each.value.app_type}-${each.value.app_category}-${each.value.app_name}"].id
}