locals {
  working_directory = "${each.value.base_directory}/${each.value.app_type}/${each.value.app_category}/${each.value.app_name}"
}