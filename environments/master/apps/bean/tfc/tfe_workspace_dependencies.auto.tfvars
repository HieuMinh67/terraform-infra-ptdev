workspaces = [
    {
      base_directory   = "/environments/master"
      app_type         = "apps"
      app_category     = "bean"
      app_name         = "vpc"
      auto_apply       = true
      depends_on       = ""
      execution_mode   = "remote"
      trigger_prefixes = []
    },
    {
      base_directory   = "/environments/master"
      app_type         = "apps"
      app_category     = "bean"
      app_name         = "bastion"
      auto_apply       = true
      depends_on       = "apps-bean-vpc"
      execution_mode   = "remote"
      trigger_prefixes = []
    },   
    {
      base_directory   = "/environments/master"
      app_type         = "apps"
      app_category     = "bean"
      app_name         = "eks-proxy"
      auto_apply       = true
      depends_on       = "apps-bean-bastion"
      execution_mode   = "local"
      trigger_prefixes = []
    },   
    {
      base_directory   = "/environments/master"
      app_type         = "apps"
      app_category     = "bean"
      app_name         = "eks-cluster"
      auto_apply       = true
      depends_on       = "apps-bean-eks-proxy"
      execution_mode   = "local"
      trigger_prefixes = []
    },
    {
      base_directory   = "/environments/master"
      app_type         = "apps"
      app_category     = "main"
      app_name         = "vpc2"
      auto_apply       = true
      depends_on       = "apps-bean-vpc"
      execution_mode   = "remote"
      trigger_prefixes = []
    }
  ]