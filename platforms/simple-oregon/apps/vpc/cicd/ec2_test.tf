data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["KopsBastionUbuntu20Focal*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["249617153445"] # SharedBean ???
}

data "aws_ami" "amazon2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.20211103.1-arm64-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"] # Canonical
}

# resource "aws_instance" "bastion" {
#   ami                    = data.aws_ami.ubuntu.id
#   instance_type          = "t3.micro"
#   subnet_id              = module.skeleton.vpc_public_subnet_ids[0]
#   vpc_security_group_ids = [aws_security_group.allow_all.id]

#   key_name = "shared_deployer_peterbean"

#   tags = {
#     Name = "Kops Bastion"
#   }
# }

# resource "aws_instance" "private" {
#   ami                    = data.aws_ami.amazon2.id
#   instance_type          = "t4g.micro"
#   subnet_id              = module.skeleton.vpc_private_subnet_ids[0]
#   vpc_security_group_ids = [aws_security_group.allow_all.id]

#   key_name = "shared_deployer_peterbean"

#   tags = {
#     Name = "Kops PrivateInstance"
#   }
# }


# data "aws_eks_cluster" "eks" {
#   name = module.eks.cluster_id
# }

# data "aws_eks_cluster_auth" "eks" {
#   name = module.eks.cluster_id
# }

# provider "kubernetes" {
#   host                   = data.aws_eks_cluster.eks.endpoint
#   cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
#   token                  = data.aws_eks_cluster_auth.eks.token
# }

# module "eks" {
#   source = "terraform-aws-modules/eks/aws"

#   cluster_version = "1.21"
#   cluster_name    = "my-cluster"
#   vpc_id          = "vpc-06e759b94f2c2eea0"
#   subnets         = ["subnet-004014c1a85a75b6b", "subnet-0954f86b60b600a9d"]

#   worker_groups = [
#     {
#       instance_type = "m4.large"
#       asg_max_size  = 5
#     }
#   ]
# }