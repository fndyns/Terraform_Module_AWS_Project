# Define the variable for the EC2 instance ID
variable "instance_id" {}

# Create an AMI from the specified EC2 instance
resource "aws_ami_from_instance" "ubuntu_ami" {
  name               = "ubuntu-ami"  # Name for the new AMI
  source_instance_id = var.instance_id  # ID of the source EC2 instance to create the AMI from
  depends_on         = [var.instance_id]  # Ensure that the AMI creation depends on the instance ID
}

# Output the ID of the created AMI
output "ami_id" {
  value = aws_ami_from_instance.ubuntu_ami.id  # Reference to the AMI ID output from the aws_ami_from_instance resource
}

