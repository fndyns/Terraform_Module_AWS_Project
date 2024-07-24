# Define the CIDR block for the VPC
variable "vpc_cidr" {
  description = "CIDR block for the VPC"  # Description of the variable
  type        = string  # Data type of the variable
}

# Define the name of the VPC
variable "vpc_name" {
  description = "Name of the VPC"  # Description of the variable
  type        = string  # Data type of the variable
}

# Define the CIDR block for the subnet
variable "subnet_cidr" {
  description = "CIDR block for the subnet"  # Description of the variable
  type        = string  # Data type of the variable
}

# Define the name of the subnet
variable "subnet_name" {
  description = "Name of the subnet"  # Description of the variable
  type        = string  # Data type of the variable
}

# Define the name of the Internet Gateway
variable "igw_name" {
  description = "Name of the Internet Gateway"  # Description of the variable
  type        = string  # Data type of the variable
}

# Define the name of the Route Table
variable "rt_name" {
  description = "Name of the Route Table"  # Description of the variable
  type        = string  # Data type of the variable
}

# Define the name of the Security Group
variable "sg_name" {
  description = "Name of the Security Group"  # Description of the variable
  type        = string  # Data type of the variable
}

