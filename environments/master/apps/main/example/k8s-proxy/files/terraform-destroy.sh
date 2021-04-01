cd terraform-infra/environments/master/apps/main/example/k8s
terraform state rm module.$1.module.$2.kubernetes_config_map.aws_auth[0]
terraform destroy -auto-approve
