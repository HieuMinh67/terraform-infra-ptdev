echo $1 > token.txt
gh auth login --with-token < token.txt
gh repo clone BeanTraining/terraform-infra && cd terraform-infra/ && git checkout $7 && cd environments/master/apps/bean/eks-cluster
# TFE_TOKEN
printf "credentials \"app.terraform.io\" { \n token = \"$2\" \n }" > ~/.terraformrc
# K8S backend.tf
printf "terraform { \n  required_version = \">= 0.12.0\" \n    backend \"remote\" { \n hostname = \"app.terraform.io\" \n organization = \"$6\" \n workspaces { \n name = \"$7-apps-bean-eks-cluster\" \n } } }" > backend.tf
terraform init
aws --profile default configure set aws_access_key_id "$3"
aws --profile default configure set aws_secret_access_key "$4"
aws --profile default configure set region "$5"
aws --profile default configure set output "json"
printf "aws_access_key_id = \"$3\" \n" > aws.auto.tfvars
printf "aws_secret_access_key = \"$4\" \n" >> aws.auto.tfvars

# aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)

# For Debug Only
printf "aws_secret_access_key = \"$4\" \n aws_access_key_id = \"$3\" \n github_oauth_token = \"$1\" \n tfe_token = \"$2\" \n private_key = <<-EOF \n $8 \n EOF" > ../eks-proxy/eks-cluster.auto.tfvars


