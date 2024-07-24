# Variable for the name of the launch configuration
variable "launch_config_name" {
  description = "Name of the launch configuration"  # Description of the variable
  type        = string  # Type of the variable is string
}

# Variable for the AMI ID to be used in the launch configuration
variable "ami_id" {
  description = "AMI ID for the launch configuration"  # Description of the variable
  type        = string  # Type of the variable is string
}

# Variable for the instance type to be used in the launch configuration
variable "instance_type" {
  description = "Instance type for the launch configuration"  # Description of the variable
  type        = string  # Type of the variable is string
}

# Variable for the security group ID to be associated with the instances
variable "security_group_id" {
  description = "Security Group ID for the launch configuration"  # Description of the variable
  type        = string  # Type of the variable is string
}

# Variable for the subnet ID in which the autoscaling group will launch instances
variable "subnet_id" {
  description = "Subnet ID for the autoscaling group"  # Description of the variable
  type        = string  # Type of the variable is string
}

# Variable for the name of the autoscaling group
variable "autoscaling_group_name" {
  description = "Name of the autoscaling group"  # Description of the variable
  type        = string  # Type of the variable is string
}

