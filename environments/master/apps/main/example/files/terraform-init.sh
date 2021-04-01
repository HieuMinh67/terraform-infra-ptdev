echo $1 > token.txt
gh auth login --with-token < token.txt
gh repo clone BeanTraining/terraform-infra && cd terraform-infra/ && git checkout dev-oregon && cd environments/master/apps/main/example/k8s
printf "credentials \"app.terraform.io\" { \n token = \"$2\" \n }" >~/.terraformrc
terraform init
aws --profile default configure set aws_access_key_id "$3"
aws --profile default configure set aws_secret_access_key "$4"
aws --profile default configure set region "$5"
aws --profile default configure set output "json"
printf "aws_access_key_id = \"$3\" " > aws.auto.tfvars
print "aws_secret_access_key = \"$4\" " >> aws.auto.tfvars
# aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)
