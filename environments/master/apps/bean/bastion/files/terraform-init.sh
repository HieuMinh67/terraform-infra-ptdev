echo $1 > token.txt
gh auth login --with-token < token.txt
gh repo clone BeanTraining/terraform-infra && cd terraform-infra/ && git checkout $7 && cd environments/master/apps/bean/eks-cluster
printf "credentials \"app.terraform.io\" { \n token = \"$2\" \n }" > ~/.terraformrc
printf "terraform { \n  required_version = \">= 0.12.0\" \n    backend \"remote\" { hostname = \"app.terraform.io\" organization = \"$6\" \n workspaces { name = \"$7-apps-bean-eks-cluster\" } } }" > backend.tf
terraform init
aws --profile default configure set aws_access_key_id "$3"
aws --profile default configure set aws_secret_access_key "$4"
aws --profile default configure set region "$5"
aws --profile default configure set output "json"
printf "aws_access_key_id = \"$3\" \n" > aws.auto.tfvars
printf "aws_secret_access_key = \"$4\" \n" >> aws.auto.tfvars
# aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)
