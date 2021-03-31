cp ../../../../master/apps/main/tfc/tfe_workspaces.tf .
# sed -i 's/sourceable_id = each.value.depends_on == "" ? data.tfe_workspace.bean-tfc.id : tfe_workspace.bean\["\${var.environment}-\${each.value.depends_on}"].id/sourceable_id = data.tfe_workspace.bean-tfc.id /g' tfe_workspaces.tf
sed -i 's/master/null/g' tfe_workspaces.tf
sed -i 's/queue_all_runs      = each.value.depends_on == "" ? true : false/queue_all_runs      = true/g' tfe_workspaces.tf
sed -i 's/\${each.value.base_directory}\/\${each.value.app_type}\/\${each.value.app_category}\/\${each.value.app_name}/\/environments\/null/g' tfe_workspaces.tf
