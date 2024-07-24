# Output the ID of the EC2 instance
output "instance_id" {
  value = aws_instance.ubuntu.id  # The ID of the created EC2 instance
}

# Output the ID of the AMI created from the EC2 instance
output "ami_id" {
  value = aws_ami_from_instance.ubuntu_ami.id  # The ID of the created AMI
}

