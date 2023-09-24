# How to create an AWS Nuke Lambda function

This folder contains Terraform files used to provision a Lambda function written in GoLang. The Lambda function is designed to implement AWS Nuke, a powerful tool that allows us to clean all resources within an AWS account, ensuring cost optimization. Leveraging Terraform's infrastructure as code capabilities, we define the necessary AWS Lambda resources, including function code, permissions, and execution schedule. This Lambda function is then scheduled to run at specified intervals, providing us with a hands-free approach to regularly invoke AWS Nuke and maintain the cleanliness of our AWS environment. This automation not only simplifies resource cleanup but also contributes to the overall efficiency and cost-effectiveness of our cloud operations.

## Prerequisites

1. **Terraform Cloud (TFC) Account**

2. **Git**

3. **AWS Account**: You may need two accounts, one for provisioning the Lambda Function, and one which is being cleaned up

## Getting Started

### Step 1: Fork and clone repositories

https://github.com/BeanTraining/terraform-infra-ptdev (Ptdev)
https://github.com/BeanTraining/terraform-infra-skeleton (Skeleton)
https://github.com/BeanTraining/cloud-nuke-centre (Nuke)

### Step 2: Set up Ptdev

Replace the **source** attribute value with the path to the **tfe_workspace** folder which belongs to your forked **Skeleton** repository. After editing commit changes

```hcl
# platforms/simple-oregon/apps/tfc/workspace/main.tf

module "tfe_workspaces" {
  source = "git::ssh://git@github.com/BeanTraining/terraform-infra-skeleton.git//apps/tfe_workspace"
  ...
}
```

### Step 3: Initialize Ptdev Workspace
Follow [Hasicorp's instruction](https://developer.hashicorp.com/terraform/tutorials/cloud-get-started/cloud-workspace-create) to create a cloud workspace for Ptdev and configure workspace variables

### Step 4: Trigger Nuke CI build
After planning Ptdev, make push event to the forked Nuke repository to trigger Github Action workflows
