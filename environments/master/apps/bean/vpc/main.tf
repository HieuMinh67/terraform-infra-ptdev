module "skeleton" {
  source          = "../../../../../skeleton/apps/vpc"
  app_name        = local.app_name
  cidr_block      = var.cidr_block
  bounded_context = var.bounded_context
}

  resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC+MPbSoDnncbAAFGw0aammN5bimYrQ1533jyiYr3fTa8aN7U1CEbKBdnK1KUSubEVMtTyVGqcJ5EWoZo0sNkdFcjauhtuoojD7J6TKq6ML/YzUbNpTZo0l4Zq/N2PG/jM3Nyj4y6j2YKAkQK6FSofwY41Z+uiifTEcico2mSRuqwxSucEPGVZZ4x0mR2CbNnV5oTEF+KTktqVx+pw8d3wMtQWAu4f/HgeoQudXLNsyjzhb57JxpXKDVj+tNVKt5W9xBdSZqe2wb7f5xSay95sIJXZK6xUhUaVe57kxR2QiXUfapAIG4B2nheHdaFhINDrq01s8JZCCoTFzOHMXuEId centos@moodle.pnt.edu.vn"
}