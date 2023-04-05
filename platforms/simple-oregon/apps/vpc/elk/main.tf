module "skeleton" {
  source                     = "git::ssh://git@github.com/BeanTraining/terraform-infra-skeleton.git//apps/vpc?ref=ptdev"
  vpc_name                   = "${var.app_name}-${var.app_category}-${var.app_type}-${var.platform}-${var.environment}"
  bounded_context            = "network"
  nat_instance_sg_id         = aws_security_group.allow_all.id
  aws_region                 = var.aws_region
  cidr_block                 = var.cidr_block
  public_subnet_cidr_blocks  = var.public_subnet_cidr_blocks
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow ALL inbound traffic"
  vpc_id      = module.skeleton.vpc_id

  ingress {
    description      = "TLS from VPC"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_all"
  }
}

module "from_ptdev_elk_to_ptdev_kops" {
  source      = "git::ssh://git@github.com/BeanTraining/terraform-infra-skeleton.git//transit/vpc_peering"
  peer_vpc_id = data.aws_vpc.ptdev_kops.id
  vpc_id      = module.skeleton.vpc_id
  providers = {
    aws.peer = aws
  }
}