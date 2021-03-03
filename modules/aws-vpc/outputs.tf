output "bean_vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.bean.id
}

output "bean_vpc_default_route_table_id" {
  description = "The ID of the default routing table for the VPC"
  value       = aws_vpc.bean.default_route_table_id
}
