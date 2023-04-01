output "vpc_id" {
  value = module.skeleton.vpc_id
}

output "vpc_private_subnet_ids" {
  value = module.skeleton.vpc_private_subnet_ids
}

output "vpc_default_security_group_id" {
  value = module.skeleton.vpc_default_security_group_id
}

output "vpc_public_subnet_ids" {
  value = module.skeleton.vpc_public_subnet_ids
}
