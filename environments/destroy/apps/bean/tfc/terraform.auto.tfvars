workspaces = [
    {
      base_directory   = "/environments/master"
      app_type         = "apps"
      app_category     = "bean"
      app_name         = "vpc"
      auto_apply       = true
      depends_on       = "apps-bean-bastion"
      trigger_prefixes = []
    },
    {
      base_directory   = "/environments/master"
      app_type         = "apps"
      app_category     = "bean"
      app_name         = "bastion"
      auto_apply       = true
      depends_on       = ""
      trigger_prefixes = []
    },
    {
      base_directory   = "/environments/master"
      app_type         = "apps"
      app_category     = "main"
      app_name         = "vpc2"
      auto_apply       = true
      depends_on       = ""
      trigger_prefixes = []
    }
  ]