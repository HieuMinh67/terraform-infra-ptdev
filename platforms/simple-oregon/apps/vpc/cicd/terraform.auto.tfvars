cidr_block      = "10.1.0.0/16"
bounded_context = "network"
app_name        = "cicd"
app_category    = "vpc"
app_type        = "apps"

private_subnet_cidr_blocks = ["10.1.0.0/20", "10.1.16.0/20", "10.1.32.0/20", "10.1.48.0/20"]

public_subnet_cidr_blocks = ["10.1.64.0/20", "10.1.80.0/20", "10.1.96.0/20", "10.1.112.0/20"]

nat_instance_private_ip = "10.1.64.10"
