terraform {
  required_version = ">= 0.12.0"
    backend "remote" {
          hostname = "app.terraform.io"

    organization = "BeanTraining"

    workspaces {
      name = "example"
    }
  }

}

provider "aws" {
  version = ">= 3.25.0"
  region  = var.region
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}
variable "aws_secret_access_key" {
  type = string
  default = "aws_secret_access_key"
  }
variable "aws_access_key_id" {
  type = string
  }
provider "random" {
  version = "~> 2.1"
}

provider "local" {
  version = "~> 1.2"
}

provider "null" {
  version = "~> 2.1"
}

provider "template" {
  version = "~> 2.1"
}

data "aws_availability_zones" "available" {
}

locals {
  cluster_name = "test-eks-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}
  
resource "aws_security_group" "cluster" {
  name_prefix = "cluster_security_group"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    security_groups = [
      module.bastion.sg_id,
      aws_security_group.all_worker_mgmt.id  
    ]
  }
    
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Custom Cluster SG - Allow pods to communicate with the EKS cluster API."
  }

}

resource "aws_security_group" "worker_group_mgmt_one" {
  name_prefix = "worker_group_mgmt_one"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/8",
    ]
  }
}

resource "aws_security_group" "worker_group_mgmt_two" {
  name_prefix = "worker_group_mgmt_two"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "192.168.0.0/16",
    ]
  }
}

resource "aws_security_group" "all_worker_mgmt" {
  name_prefix = "all_worker_management"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/8",
      "172.16.0.0/12",
      "192.168.0.0/16",
    ]
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.77.0"

  name                 = "test-vpc"
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}
  
  output "vpc_private_subnet_ids" {
    value = module.vpc.private_subnets
    }
    
output "region" {
  description = "AWS region."
  value       = var.region
}

  output "cluster_name" {
    value = local.cluster_name
    }
  
  resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC+MPbSoDnncbAAFGw0aammN5bimYrQ1533jyiYr3fTa8aN7U1CEbKBdnK1KUSubEVMtTyVGqcJ5EWoZo0sNkdFcjauhtuoojD7J6TKq6ML/YzUbNpTZo0l4Zq/N2PG/jM3Nyj4y6j2YKAkQK6FSofwY41Z+uiifTEcico2mSRuqwxSucEPGVZZ4x0mR2CbNnV5oTEF+KTktqVx+pw8d3wMtQWAu4f/HgeoQudXLNsyjzhb57JxpXKDVj+tNVKt5W9xBdSZqe2wb7f5xSay95sIJXZK6xUhUaVe57kxR2QiXUfapAIG4B2nheHdaFhINDrq01s8JZCCoTFzOHMXuEId centos@moodle.pnt.edu.vn"
}

 
  module "bastion" {
  source            = "github.com/BeanTraining/terraform-aws-bastion-host"  
  subnet_id         = module.vpc.public_subnets[0]
  ssh_key           = "deployer-key"
  internal_networks = ["10.0.0.0/16"]
  disk_size         = 12
  instance_type     = "t2.micro"
  project           = "myProject"
}
output "vpc_id" {
  value = module.vpc.vpc_id
    }
  
    output "bastion_ip" {
      value = module.bastion.public_ip
      }
      
      output "bastion_sg_id" {
        value = module.bastion.sg_id
          }
