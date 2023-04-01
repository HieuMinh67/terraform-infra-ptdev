cidr_block      = "10.3.0.0/16"
bounded_context = "network"
app_name        = "prometheus"
app_category    = "vpc"
app_type        = "apps"

private_subnet_cidr_blocks = ["10.3.0.0/20", "10.3.16.0/20", "10.3.32.0/20", "10.3.48.0/20"]

public_subnet_cidr_blocks = ["10.3.64.0/20", "10.3.80.0/20", "10.3.96.0/20", "10.3.112.0/20"]

nat_instance_private_ip = "10.3.64.6"
