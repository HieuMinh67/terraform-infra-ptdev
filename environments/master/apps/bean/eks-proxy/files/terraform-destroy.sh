cd terraform-infra/environments/master/apps/bean/eks-cluster
terraform state rm module.$1.kubernetes_config_map.aws_auth[0]
terraform destroy -auto-approve
