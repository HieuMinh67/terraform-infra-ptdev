cidr_block      = "10.2.0.0/16"
bounded_context = "network"
app_name        = "elk"
app_category    = "vpc"
app_type        = "apps"

private_subnet_cidr_blocks = ["10.2.0.0/20", "10.2.16.0/20", "10.2.32.0/20", "10.2.48.0/20"]

public_subnet_cidr_blocks = ["10.2.64.0/20", "10.2.80.0/20", "10.2.96.0/20", "10.2.112.0/20"]

nat_instance_private_ip = "10.2.64.6"
