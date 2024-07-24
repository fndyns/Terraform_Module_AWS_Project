# AMI ID for the EC2 instance
variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

# Instance type for the EC2 instance
variable "instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
}

# Subnet ID for the EC2 instance
variable "subnet_id" {
  description = "Subnet ID for the EC2 instance"
  type        = string
}

# Security Group ID for the EC2 instance
variable "security_group_id" {
  description = "Security Group ID for the EC2 instance"
  type        = string
}

# Key name for SSH access
variable "key_name" {
  description = "Key name for SSH access"
  type        = string
}

# Name of the EC2 instance
variable "instance_name" {
  description = "Name of the EC2 instance"
  type        = string
}

# Name of the created AMI
variable "ami_name" {
  description = "Name of the created AMI"
  type        = string
}

