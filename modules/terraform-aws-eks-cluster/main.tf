locals {
  cluster_name = var.cluster_name != "" ? var.cluster_name : lower("${var.environment}-${var.application}")

  tags = merge(
    {
      Name = local.cluster_name
    },
    module.cluster_tags.eks,
    var.additional_tags,
  )
}

resource "aws_eks_cluster" "bean" {
  name     = local.cluster_name
  role_arn = aws_iam_role.bean.arn
  version  = var.kubernetes_version

  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler",
  ]

  vpc_config {
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access

    security_group_ids = [
      aws_security_group.bean.id
    ]

    subnet_ids = var.subnet_ids
  }

  tags = local.tags
}

resource "aws_iam_openid_connect_provider" "bean" {
  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    var.thumbprint
  ]

  url = aws_eks_cluster.this.identity.0.oidc.0.issuer
}

resource "aws_security_group" "bean" {
  name   = local.cluster_name
  vpc_id = var.vpc_id

  egress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]

    from_port = 0
    protocol  = "-1"
    to_port   = 0
  }

  tags = local.tags
}

resource "aws_security_group_rule" "bean" {
  from_port         = 443
  to_port           = 443
  cidr_blocks       = var.ingress_443_cidrs
  description       = "Allowed CIDRs for api access"
  security_group_id = aws_security_group.bean.id
  type              = "ingress"
  protocol          = "tcp"
}
