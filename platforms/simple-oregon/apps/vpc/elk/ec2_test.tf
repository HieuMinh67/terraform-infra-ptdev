# data "aws_ami" "ubuntu" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["KopsBastionUbuntu20Focal*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   owners = ["249617153445"] # SharedBean ???
# }

# data "aws_ami" "amazon2" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["amzn2-ami-kernel-5.10-hvm-2.0.20211103.1-arm64-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   owners = ["amazon"] # Canonical
# }

# # resource "aws_instance" "bastion" {
# #   ami                    = data.aws_ami.ubuntu.id
# #   instance_type          = "t3.micro"
# #   subnet_id              = module.skeleton.vpc_public_subnet_ids[0]
# #   vpc_security_group_ids = [aws_security_group.allow_all.id]

# #   key_name = "shared_deployer_peterbean"

# #   tags = {
# #     Name = "Kops Bastion"
# #   }
# # }

# # resource "aws_instance" "private" {
# #   ami                    = data.aws_ami.amazon2.id
# #   instance_type          = "t4g.micro"
# #   subnet_id              = module.skeleton.vpc_private_subnet_ids[0]
# #   vpc_security_group_ids = [aws_security_group.allow_all.id]

# #   key_name = "shared_deployer_peterbean"

# #   tags = {
# #     Name = "Kops PrivateInstance"
# #   }
# # }


