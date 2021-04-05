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
  default = [
    {
      base_directory   = "/environments/master"
      app_type         = "apps"
      app_category     = "bean"
      app_name         = "vpc"
      auto_apply       = true
      depends_on       = ""
      trigger_prefixes = []
    },
    {
      base_directory   = "/environments/master"
      app_type         = "apps"
      app_category     = "bean"
      app_name         = "bastion"
      auto_apply       = true
      depends_on       = "apps-bean-vpc"
      trigger_prefixes = []
    },
    {
      base_directory   = "/environments/master"
      app_type         = "apps"
      app_category     = "main"
      app_name         = "vpc2"
      auto_apply       = true
      depends_on       = "apps-bean-vpc"
      trigger_prefixes = []
    }
  ]
}

  
resource "tfe_workspace" "this" {
  for_each            = { for ws in var.workspaces : "${var.environment}-${ws.app_type}-${ws.app_category}-${ws.app_name}" => ws }
  name                = "${var.environment}-${each.value.app_type}-${each.value.app_category}-${each.value.app_name}"
  organization        = "BeanTraining"
  speculative_enabled = true
  queue_all_runs      = each.value.depends_on == "" ? true : false
  working_directory   = "${each.value.base_directory}/${each.value.app_type}/${each.value.app_category}/${each.value.app_name}"
  trigger_prefixes = concat(each.value.trigger_prefixes,
    [
      "${each.value.base_directory}/${each.value.app_type}/${each.value.app_category}/${each.value.app_name}",
      "${each.value.base_directory}/apps/bean/tfc/releases"
    ]
  )
  vcs_repo {
    identifier     = "BeanTraining/terraform-infra"
    branch         = var.environment
    oauth_token_id = tfe_oauth_client.this-github.oauth_token_id
  }
  auto_apply = each.value.auto_apply
}