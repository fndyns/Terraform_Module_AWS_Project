# Configuring the AWS provider with the desired region
provider "aws" {
  region = "us-east-1"
}

# VPC module to create a Virtual Private Cloud and related resources
module "vpc" {
  source        = "./modules/vpc"        # Source path of the VPC module
  vpc_cidr      = "10.0.0.0/16"          # CIDR block for the VPC
  vpc_name      = "main_vpc"             # Name tag for the VPC
  subnet_cidr   = "10.0.1.0/24"          # CIDR block for the subnet
  subnet_name   = "main_subnet"          # Name tag for the subnet
  igw_name      = "main_igw"             # Name tag for the internet gateway
  rt_name       = "main_rt"              # Name tag for the route table
  sg_name       = "main_sg"              # Name tag for the security group
}

# EC2 module to create an EC2 instance
module "ec2" {
  source            = "./modules/ec2"            # Source path of the EC2 module
  ami_id            = "ami-039c19f6de5d8bd93"    # AMI ID for the EC2 instance
  instance_type     = "t2.micro"                 # Type of the EC2 instance
  subnet_id         = module.vpc.subnet_id       # ID of the subnet from the VPC module
  security_group_id = module.vpc.security_group_id # ID of the security group from the VPC module
  key_name          = "my-ssh-key"               # Name of the SSH key pair
  instance_name     = "UbuntuInstance"           # Name tag for the EC2 instance
  ami_name          = "ubuntu-ami"               # Name for the created AMI
}

# Auto Scaling module to set up an Auto Scaling group and related resources
module "autoscaling" {
  source                 = "./modules/autoscaling"   # Source path of the Auto Scaling module
  launch_config_name     = "launch_config"           # Name for the launch configuration
  ami_id                 = module.ec2.ami_id         # AMI ID from the EC2 module
  instance_type          = "t2.micro"                # Type of the instances
  security_group_id      = module.vpc.security_group_id # ID of the security group from the VPC module
  subnet_id              = module.vpc.subnet_id      # ID of the subnet from the VPC module
  autoscaling_group_name = "AutoScalingGroup"        # Name tag for the Auto Scaling group
}

# Lambda module to create a Lambda function and related resources
module "lambda" {
  source                   = "./modules/lambda"       # Source path of the Lambda module
  lambda_function_name     = "billing_alert"          # Name for the Lambda function
  lambda_role_name         = "lambda_exec_role"       # Name for the Lambda execution role
  lambda_policy_name       = "lambda_policy"          # Name for the Lambda policy
  cloudwatch_event_rule_name = "ec2_termination_rule" # Name for the CloudWatch event rule
  billing_alert_email      = var.billing_alert_email  # Email address for billing alerts
}

# CloudWatch module to create CloudWatch alarms and related resources
module "cloudwatch" {
  source          = "./modules/cloudwatch"             # Source path of the CloudWatch module
  alarm_name      = "instance_up_overnight"            # Name for the CloudWatch alarm
  sns_topic_arn   = module.lambda.lambda_function_arn  # ARN of the SNS topic from the Lambda module
  instance_id     = module.ec2.instance_id             # ID of the EC2 instance from the EC2 module
  alarm_email     = var.alarm_email                    # Email address for alarm notifications
}

