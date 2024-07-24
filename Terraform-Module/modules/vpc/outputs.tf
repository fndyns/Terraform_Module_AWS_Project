# Output the ID of the created VPC
output "vpc_id" {
  value = aws_vpc.main.id  # The ID of the main VPC created in the module
}

# Output the ID of the created subnet
output "subnet_id" {
  value = aws_subnet.subnet.id  # The ID of the subnet created within the VPC
}

# Output the ID of the created security group
output "security_group_id" {
  value = aws_security_group.sg.id  # The ID of the security group created within the VPC
}

