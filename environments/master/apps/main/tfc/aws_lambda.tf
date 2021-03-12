/**
  tfe_variables.tf
- aws_region
*/
  
# https://learn.hashicorp.com/tutorials/terraform/lambda-api-gateway?in=terraform/aws

provider "aws" {
   region = var.aws_region
}

# EFS access point used by lambda file system
resource "aws_efs_access_point" "access_point_for_lambda" {
  file_system_id = aws_efs_file_system.efs_for_lambda.id

  root_directory {
    path = "/lambda"
    creation_info {
      owner_gid   = 1000
      owner_uid   = 1000
      permissions = "777"
    }
  }

  posix_user {
    gid = 1000
    uid = 1000
  }
}

# EFS file system
resource "aws_efs_file_system" "efs_for_lambda" {
}

# Mount target connects the file system to the subnet
resource "aws_efs_mount_target" "bean" {
  file_system_id  = aws_efs_file_system.efs_for_lambda.id
  subnet_id       = aws_subnet.subnet_for_lambda.id
  security_groups = [aws_security_group.sg_for_lambda.id]
}

resource "aws_subnet" "subnet_for_lambda" {
  vpc_id     = aws_vpc.vpc_for_lambda.id
  cidr_block = "10.0.1.0/24"
}
resource "aws_vpc" "vpc_for_lambda" {
  cidr_block = "10.0.0.0/16"
}
resource "aws_security_group" "sg_for_lambda" {
  name        = "sg_for_lambdaV1"
  description = "sg_for_lambda"
  vpc_id      = aws_vpc.vpc_for_lambda.id
   ingress {
    description = "NFS"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc_for_lambda.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
    lifecycle {
    create_before_destroy = true
  }
}


resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": 
 "sts:AssumeRole"
      ,
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "AWSLambdaVPCAccessExecutionRole" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

data "aws_s3_bucket_object" "notification" {
  bucket = "479284709538-${var.aws_region}-aws-lambda"
  key    = "terraform-api/latest/notification.zip"
}


