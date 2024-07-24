# Create an EC2 instance resource
resource "aws_instance" "ubuntu" {
  ami                         = var.ami_id                # The AMI ID to use for the instance
  instance_type               = var.instance_type         # The instance type (e.g., t2.micro)
  subnet_id                   = var.subnet_id             # The ID of the subnet in which to launch the instance
  vpc_security_group_ids      = [var.security_group_id]   # The security group IDs to associate with the instance
  key_name                    = var.key_name              # The name of the SSH key pair to use for the instance
  associate_public_ip_address = true                      # Whether to associate a public IP address with the instance

  tags = {
    Name = var.instance_name  # The name tag for the instance
  }
}

# Create an AMI from the EC2 instance
resource "aws_ami_from_instance" "ubuntu_ami" {
  name               = var.ami_name                # The name of the AMI to create
  source_instance_id = aws_instance.ubuntu.id      # The ID of the source instance to create the AMI from
  depends_on         = [aws_instance.ubuntu]       # Ensure the source instance is created before the AMI
}

