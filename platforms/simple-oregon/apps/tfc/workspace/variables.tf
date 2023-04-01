# tfe_workspace_commons.tf
variable "workspaces" {
  type = list(object({
    app_type         = string
    app_category     = string
    app_name         = string
    auto_apply       = bool
    trigger_prefixes = list(string)
    depends_on       = string
    execution_mode   = string
    is_vcs_connected = bool
  }))
}

variable "api_key" {
  default = "123456789"
}

variable "organisation" {
  default = "BeanTraining"
}

variable "environment" {}

# tfe_variables.tf
variable "private_key" {}
variable "platform" {}

variable "infra_stage" {}
# tfe_variables.tf but only required for child ws
variable "aws_account_id" {}
variable "aws_access_key_id" {}
variable "aws_secret_access_key" {}
variable "tfe_token" {}
variable "github_oauth_token" {}

# variable "ssh_key_name" {
#   default = ""
# }

variable "state" {}