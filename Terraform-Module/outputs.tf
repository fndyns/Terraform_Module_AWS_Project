# Output the ID of the created VPC
output "vpc_id" {
  value = module.vpc.vpc_id  # Reference to the VPC ID output from the VPC module
}

# Output the ID of the created subnet
output "subnet_id" {
  value = module.vpc.subnet_id  # Reference to the subnet ID output from the VPC module
}

# Output the ID of the created security group
output "security_group_id" {
  value = module.vpc.security_group_id  # Reference to the security group ID output from the VPC module
}

# Output the ID of the created EC2 instance
output "instance_id" {
  value = module.ec2.instance_id  # Reference to the instance ID output from the EC2 module
}

# Output the ID of the created AMI
output "ami_id" {
  value = module.ec2.ami_id  # Reference to the AMI ID output from the EC2 module
}

# Output the ID of the created Auto Scaling Group
output "autoscaling_group_id" {
  value = module.autoscaling.autoscaling_group_id  # Reference to the Auto Scaling Group ID output from the Auto Scaling module
}

# Output the ARN of the created Lambda function
output "lambda_function_arn" {
  value = module.lambda.lambda_function_arn  # Reference to the Lambda function ARN output from the Lambda module
}

# Output the ARN of the created CloudWatch alarm
output "cloudwatch_alarm_arn" {
  value = module.cloudwatch.cloudwatch_alarm_arn  # Reference to the CloudWatch alarm ARN output from the CloudWatch module
}

