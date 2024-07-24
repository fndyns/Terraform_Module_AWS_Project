# Create the main VPC resource
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr  # The CIDR block for the VPC, provided as a variable

  tags = {
    Name = var.vpc_name  # Tag the VPC with a name, provided as a variable
  }
}

# Create a subnet within the VPC
resource "aws_subnet" "subnet" {
  vpc_id     = aws_vpc.main.id  # Reference the VPC created above
  cidr_block = var.subnet_cidr  # The CIDR block for the subnet, provided as a variable

  tags = {
    Name = var.subnet_name  # Tag the subnet with a name, provided as a variable
  }
}

# Create an internet gateway for the VPC
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id  # Reference the VPC created above

  tags = {
    Name = var.igw_name  # Tag the internet gateway with a name, provided as a variable
  }
}

# Create a route table for the VPC
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id  # Reference the VPC created above

  route {
    cidr_block = "0.0.0.0/0"  # The CIDR block for the default route
    gateway_id = aws_internet_gateway.igw.id  # Reference the internet gateway created above
  }

  tags = {
    Name = var.rt_name  # Tag the route table with a name, provided as a variable
  }
}

# Associate the route table with the subnet
resource "aws_route_table_association" "rta" {
  subnet_id      = aws_subnet.subnet.id  # Reference the subnet created above
  route_table_id = aws_route_table.rt.id  # Reference the route table created above
}

# Create a security group within the VPC
resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.main.id  # Reference the VPC created above

  ingress {
    from_port   = 22  # Allow incoming traffic on port 22 (SSH)
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow traffic from anywhere
  }

  egress {
    from_port   = 0  # Allow all outbound traffic
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow traffic to anywhere
  }

  tags = {
    Name = var.sg_name  # Tag the security group with a name, provided as a variable
  }
}

