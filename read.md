Purpose of the Infrastructure Setup

The purpose of this infrastructure setup is to create a scalable and automated environment on AWS using Terraform. This setup includes the creation of an EC2 instance with an AMI, an Auto Scaling Group, CloudWatch alarms, and a Lambda function that triggers on certain events. This modular approach allows for better organization, reusability, and maintenance of the infrastructure code.

1. Introduction

 This setup includes:

    VPC Module: Setting up a virtual private cloud to logically isolate AWS resources.
    EC2 Module: Launching an EC2 instance.
    Auto Scaling Module: Setting up an Auto Scaling group to ensure high availability.
    CloudWatch Module: Creating alarms to monitor resource utilization.
    Lambda Module: Setting up a Lambda function to trigger on specific events.


2. Pre-requisites

    AWS Account
    AWS CLI installed and configured
    Terraform installed
    SSH Key Pair for EC2 instances
    Permissions to create resources in AWS
    
3. Detailed Steps
3.1 VPC Module

    Purpose: The VPC module is responsible for creating a secure and isolated virtual network within AWS. This includes subnets, routing, and security groups that allow controlled access to the network resources.

    Components:

    VPC: The virtual network in which your resources will run.
    Subnet: A subdivision of your VPC, providing a range of IP addresses.
    Internet Gateway: Allows internet access to your VPC.
    Route Table: Manages the routing of traffic within your VPC.
    Security Group: Controls inbound and outbound traffic to your resources.
    
    File: modules/vpc/main.tf : Defines the AWS resources required to create a VPC, including subnets, internet gateway, route table, and security groups.
	    Key Components:

	    aws_vpc.main: Creates the main VPC.
	    aws_subnet.subnet: Defines a subnet within the VPC.
	    aws_internet_gateway.igw: Creates an internet gateway for the VPC.
	    aws_route_table.rt: Sets up a route table for internet access.
	    aws_route_table_association.rta: Associates the subnet with the route table.
	    aws_security_group.sg: Creates a security group to manage inbound and outbound traffic.
	    
    File: modules/vpc/variables.tf :  Declares input variables for the VPC module to allow parameterization.
	    Key Variables:

	    cidr_block: CIDR block for the VPC.
	    subnet_cidr_block: CIDR block for the subnet.
	    vpc_name, subnet_name, igw_name, rt_name, sg_name: Names for the resources.
	    
     File: modules/vpc/outputs.tf : Exposes the VPC module's outputs for use by other modules.
	    Key Outputs:

	    vpc_id: The ID of the created VPC.
	    subnet_id: The ID of the created subnet.
	    sg_id: The ID of the created security group.
          
                        
4.2 EC2 Module

    Purpose: The EC2 module is responsible for launching an EC2 instance within the created VPC. This instance will be used for various tasks such as running applications or services.
    
    Components:

    EC2 Instance: The compute resource running Ubuntu.
    
    File: modules/ec2/main.tf : Defines the AWS EC2 instance resource.
	    Key Components:

	    aws_instance.ubuntu: Creates an EC2 instance using a specified AMI, instance type, key pair, and subnet.
	    
    File: modules/ec2/variables.tf :  Declares input variables for the EC2 module to allow parameterization.
	    Key Variables:

	    ami_id: AMI ID for the EC2 instance.
	    instance_type: Type of the EC2 instance.
	    key_name: Name of the SSH key pair.
	    subnet_id, security_group_id: Subnet and security group IDs.
	    instance_name: Name tag for the EC2 instance.
	    
    File: modules/ec2/outputs.tf   : Exposes the EC2 module's outputs for use by other modules.  
	    Key Outputs:

	    instance_id: The ID of the created EC2 instance.
	    ami_id: The AMI ID used for the instance.  
	    

    

4.3 AMI Module (ami):
     
    Purpose: The ami module is designed to create an Amazon Machine Image (AMI) from an existing EC2 instance. This AMI can then be used to launch new instances with the same configuration.
    Files:
    File: main.tf: Defines the resource for creating an AMI.
		Key Resources:

	    aws_ami_from_instance: This resource creates an AMI from an existing EC2 instance. It includes configurations such as the instance ID, AMI name, and tags.
   
   File: variables.tf: Contains variables for AMI creation.
		Key Variables:

		instance_id: The ID of the EC2 instance from which the AMI will be created.
		ami_name: The name to assign to the new AMI.
   File: outputs.tf: Outputs the ID of the created AMI.	
		Key Outputs:

	        ami_id: The ID of the newly created AMI.
	        
4.4 Auto Scaling Module

    Purpose: The Auto Scaling module ensures the EC2 instances can automatically scale in and out based on predefined conditions. This helps maintain performance and manage costs by adjusting the number of running instances.
    
    Components:

    Launch Configuration: Defines the configuration for the instances in the Auto Scaling Group.
    Auto Scaling Group: Manages the scaling policies and the desired number of instances.
    Auto Scaling Schedule: Schedules the scaling actions.
    
    File: modules/autoscaling/main.tf : Defines the resources required to set up an auto-scaling group and its related configurations.
	    Key Components:

	    aws_launch_configuration.lc: Defines the launch configuration for the auto-scaling group.
	    aws_autoscaling_group.asg: Creates the auto-scaling group.
	    aws_autoscaling_schedule.scale_up: Schedules the scale-up action.
	    aws_autoscaling_schedule.scale_down: Schedules the scale-down action.
	    
    File: modules/autoscaling/variables.tf : Declares input variables for the Auto Scaling module to allow parameterization.
	    Key Variables:

	    image_id: AMI ID for instances.
	    instance_type: Type of instances.
	    security_group_id: Security group ID.
	    key_name: SSH key pair name.
	    subnet_id: Subnet ID.
	    desired_capacity, min_size, max_size: Auto-scaling parameters.
	    autoscaling_group_name: Name for the auto-scaling group.
	    
    File: modules/autoscaling/outputs.tf : Exposes the Auto Scaling module's outputs for use by other modules.
	    Key Outputs:

	    autoscaling_group_id: The ID of the created auto-scaling group.
          
4.5 CloudWatch Module

    Purpose: The CloudWatch module creates an alarm to monitor the CPU utilization of EC2 instances. If the utilization exceeds the threshold, it triggers specified actions, such as notifications or Lambda functions.
    
    Components:

    CloudWatch Alarm: Monitors the specified metric and triggers actions.
    
    File: modules/cloudwatch/main.tf : Defines the CloudWatch alarm resource.
	    Key Components:

	    aws_cloudwatch_metric_alarm.instance_up_overnight: Creates a CloudWatch alarm for CPU utilization.
	    
    File: modules/cloudwatch/variables.tf : Declares input variables for the CloudWatch module to allow parameterization.
            Key Variables:

	    alarm_name: Name of the alarm.
	    alarm_description: Description of the alarm.
	    lambda_function_arn: ARN of the Lambda function to trigger.
	    
    File: modules/cloudwatch/outputs.tf :  Exposes the CloudWatch module's outputs for use by other modules.
	    Key Outputs:

	    cloudwatch_alarm_arn: The ARN of the created CloudWatch alarm.
          
4.6 Lambda Module

    Purpose: The Lambda module creates a Lambda function that responds to EC2 instance termination events. This function can perform various tasks, such as sending notifications or triggering other actions.
    
    Components:

    IAM Role: Defines the permissions for the Lambda function.
    Lambda Function: Executes code in response to events.
    CloudWatch Event Rule: Triggers the Lambda function based on events.
    
    File: modules/lambda/main.tf : Defines the resources for the Lambda function, IAM roles, and CloudWatch event triggers.
	    Key Components:

	    aws_iam_role.lambda_exec_role: Creates an IAM role for the Lambda function.
	    aws_iam_role_policy.lambda_policy: Attaches a policy to the IAM role.
	    aws_lambda_function.billing_alert: Defines the Lambda function.
	    aws_lambda_permission.allow_cloudwatch: Grants CloudWatch permission to invoke the Lambda function.
	    aws_cloudwatch_event_rule.ec2_termination_rule: Creates a CloudWatch event rule to trigger the Lambda function.
	    aws_cloudwatch_event_target.ec2_termination_target: Sets the Lambda function as the target for the event rule.
    File: modules/lambda/variables.tf : Declares input variables for the Lambda module to allow parameterization.
	    Key Variables:

	    lambda_role_name: Name of the Lambda execution role.
	    lambda_policy_name: Name of the Lambda policy.
	    lambda_function_name: Name of the Lambda function.
	    cloudwatch_event_rule_name: Name of the CloudWatch event rule.
	    billing_alert_email: Email address to receive billing alerts.
    -       alarm_email: Email address to receive alarm notifications.
    File: modules/lambda/outputs.tf   : Exposes the Lambda module's outputs for use by other modules.
	    Key Outputs:

	    lambda_function_arn: The ARN of the created Lambda function.
    File: modules/lambda/lambda_function.py : Contains the code that the Lambda function executes in response to events.
    File: modules/lambda/lambda.zip :  The deployment package for the Lambda function.
    
SNS Notifications Configuration

To ensure that you receive notifications for specific events such as billing alerts and CloudWatch alarms, the setup includes creating SNS topics and subscriptions. The email addresses for these notifications are set using Terraform variables.

- SNS Topics:
    - billing_alerts: Used for notifications related to billing alerts.
    - alarm_topic: Used for notifications triggered by CloudWatch alarms.

- SNS Subscriptions:
    - Subscriptions are created to send notifications to specified email addresses.
    
To set the email addresses, use the following variables in the `terraform apply` command:
- billing_alert_email: Email address to receive billing alerts.
- alarm_email: Email address to receive alarm notifications.

    

Components and Configuration

    CloudWatch Event Rule: Monitors EC2 instance state changes and triggers the Lambda function when an instance is terminated.
    Lambda Function: The Lambda function in this infrastructure is designed to handle EC2 instance termination events. When an EC2 instance is terminated, the Lambda function is triggered to sending notifications through SNS.

    IAM Role and Policy: Grants the Lambda function necessary permissions to perform its tasks, such as logging to CloudWatch, sending notifications through SNS, and describing EC2 instances.
    SNS Topic: Used by the Lambda function to send notifications to a list of subscribers.
    
To summarize, this Lambda setup ensures that whenever an EC2 instance is terminated, a notification is sent to the specified email addresses through SNS.
          
5. Main Configuration

    Purpose: To call the modules and pass the necessary variables.
    File: main.tf  : The main.tf file is the primary configuration file that ties all the modules together. It defines the root module and references all the individual modules (VPC, EC2, Auto Scaling, CloudWatch, Lambda) to create the entire infrastructure.References each module (vpc, ec2, autoscaling, cloudwatch, lambda) with their respective source paths. Passes necessary variables to each module.
    
    File: variables.tf : Declares all the input variables needed for the entire infrastructure. These variables are used to parameterize the configuration and allow for dynamic inputs.
    	    Key Variables:

	    VPC Variables: vpc_cidr_block, subnet_cidr_block
	    EC2 Variables: ami_id, instance_type, key_name, subnet_id, security_group_id, instance_name
	    Auto Scaling Variables: image_id, instance_type, key_name, subnet_id, desired_capacity, min_size, max_size, autoscaling_group_name
	    CloudWatch Variables: alarm_name, alarm_description, lambda_function_arn
	    Lambda Variables: lambda_role_name, lambda_policy_name, lambda_function_name, cloudwatch_event_rule_name, billing_alert_email, alarm_email
	    
    
    File: outputs.tf : Defines the outputs that are exposed from the root module. These outputs aggregate the outputs from individual modules and make them available for reference
            Key Outputs:

	    VPC Outputs: vpc_id, subnet_id, security_group_id
	    EC2 Outputs: instance_id, ami_id
	    Auto Scaling Outputs: autoscaling_group_id
	    CloudWatch Outputs: cloudwatch_alarm_arn
	    Lambda Outputs: lambda_function_arn
    
6. Running the Terraform Script

    Initialize Terraform:  terraform init
    
		  vagrant@test:~/Nearfield/terraform_module$ terraform init

	Initializing the backend...
	Initializing modules...

	Initializing provider plugins...
	- Reusing previous version of hashicorp/aws from the dependency lock file
	- Using previously-installed hashicorp/aws v5.58.0

	Terraform has been successfully initialized!

	You may now begin working with Terraform. Try running "terraform plan" to see
	any changes that are required for your infrastructure. All Terraform commands
	should now work.

	If you ever set or change modules or backend configuration for Terraform,
	rerun this command to reinitialize your working directory. If you forget, other
	commands will detect it and remind you to do so if necessary.
	
	
    Apply the Changes: terraform apply
  

vagrant@test:~/Nearfield/terraform_module$ terraform apply -var="billing_alert_email=melikeozen935@gmail.com" -var="alarm_email=melikeozen935@gmail.com" -var="key_name=my-ssh-key"
module.lambda.aws_cloudwatch_event_rule.ec2_termination_rule: Refreshing state... [id=ec2_termination_rule]
module.lambda.aws_iam_role.lambda_exec_role: Refreshing state... [id=lambda_exec_role]
module.vpc.aws_vpc.main: Refreshing state... [id=vpc-0bc9256fe76f2d6ef]
module.lambda.aws_lambda_function.billing_alert: Refreshing state... [id=billing_alert]
module.lambda.aws_iam_role_policy.lambda_policy: Refreshing state... [id=lambda_exec_role:lambda_policy]
module.lambda.aws_lambda_permission.allow_cloudwatch: Refreshing state... [id=AllowExecutionFromCloudWatch]
module.lambda.aws_cloudwatch_event_target.ec2_termination_target: Refreshing state... [id=ec2_termination_rule-send_billing_report]
module.vpc.aws_subnet.subnet: Refreshing state... [id=subnet-0aeedc0b3763d51b8]
module.vpc.aws_internet_gateway.igw: Refreshing state... [id=igw-0adb5b4878ad45e62]
module.vpc.aws_security_group.sg: Refreshing state... [id=sg-07b4b0b3ccb181ea0]
module.vpc.aws_route_table.rt: Refreshing state... [id=rtb-02b5077fa1dbd2c5b]
module.ec2.aws_instance.ubuntu: Refreshing state... [id=i-0d21564fc91b7a854]
module.vpc.aws_route_table_association.rta: Refreshing state... [id=rtbassoc-0fde649ba12143d59]
module.cloudwatch.aws_cloudwatch_metric_alarm.instance_up_overnight: Refreshing state... [id=instance_up_overnight]
module.ec2.aws_ami_from_instance.ubuntu_ami: Refreshing state... [id=ami-0eae9df081ed81260]
module.autoscaling.aws_launch_configuration.lc: Refreshing state... [id=launch_config]
module.autoscaling.aws_autoscaling_group.asg: Refreshing state... [id=terraform-20240712062044974000000002]
module.autoscaling.aws_autoscaling_schedule.scale_down: Refreshing state... [id=scale_down_at_6pm]
module.autoscaling.aws_autoscaling_schedule.scale_up: Refreshing state... [id=scale_up_at_6am]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create
  ~ update in-place

Terraform will perform the following actions:

  # module.cloudwatch.aws_cloudwatch_metric_alarm.instance_up_overnight will be updated in-place
  ~ resource "aws_cloudwatch_metric_alarm" "instance_up_overnight" {
      ~ alarm_actions             = [
          - "arn:aws:lambda:us-east-1:572865984595:function:billing_alert",
        ] -> (known after apply)
        id                        = "instance_up_overnight"
        tags                      = {}
        # (17 unchanged attributes hidden)
    }

  # module.cloudwatch.aws_sns_topic.alarm_topic will be created
  + resource "aws_sns_topic" "alarm_topic" {
      + arn                         = (known after apply)
      + beginning_archive_time      = (known after apply)
      + content_based_deduplication = false
      + fifo_topic                  = false
      + id                          = (known after apply)
      + name                        = "alarm_topic"
      + name_prefix                 = (known after apply)
      + owner                       = (known after apply)
      + policy                      = (known after apply)
      + signature_version           = (known after apply)
      + tags_all                    = (known after apply)
      + tracing_config              = (known after apply)
    }

  # module.cloudwatch.aws_sns_topic_subscription.alarm_email_subscription will be created
  + resource "aws_sns_topic_subscription" "alarm_email_subscription" {
      + arn                             = (known after apply)
      + confirmation_timeout_in_minutes = 1
      + confirmation_was_authenticated  = (known after apply)
      + endpoint                        = "melikeozen935@gmail.com"
      + endpoint_auto_confirms          = false
      + filter_policy_scope             = (known after apply)
      + id                              = (known after apply)
      + owner_id                        = (known after apply)
      + pending_confirmation            = (known after apply)
      + protocol                        = "email"
      + raw_message_delivery            = false
      + topic_arn                       = (known after apply)
    }

  # module.lambda.aws_sns_topic.billing_alerts will be created
  + resource "aws_sns_topic" "billing_alerts" {
      + arn                         = (known after apply)
      + beginning_archive_time      = (known after apply)
      + content_based_deduplication = false
      + fifo_topic                  = false
      + id                          = (known after apply)
      + name                        = "billing_alerts"
      + name_prefix                 = (known after apply)
      + owner                       = (known after apply)
      + policy                      = (known after apply)
      + signature_version           = (known after apply)
      + tags_all                    = (known after apply)
      + tracing_config              = (known after apply)
    }

  # module.lambda.aws_sns_topic_subscription.email_subscription will be created
  + resource "aws_sns_topic_subscription" "email_subscription" {
      + arn                             = (known after apply)
      + confirmation_timeout_in_minutes = 1
      + confirmation_was_authenticated  = (known after apply)
      + endpoint                        = "melikeozen935@gmail.com"
      + endpoint_auto_confirms          = false
      + filter_policy_scope             = (known after apply)
      + id                              = (known after apply)
      + owner_id                        = (known after apply)
      + pending_confirmation            = (known after apply)
      + protocol                        = "email"
      + raw_message_delivery            = false
      + topic_arn                       = (known after apply)
    }

Plan: 4 to add, 1 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

module.cloudwatch.aws_sns_topic.alarm_topic: Creating...
module.lambda.aws_sns_topic.billing_alerts: Creating...
module.lambda.aws_sns_topic.billing_alerts: Creation complete after 1s [id=arn:aws:sns:us-east-1:572865984595:billing_alerts]
module.lambda.aws_sns_topic_subscription.email_subscription: Creating...
module.cloudwatch.aws_sns_topic.alarm_topic: Creation complete after 2s [id=arn:aws:sns:us-east-1:572865984595:alarm_topic]
module.cloudwatch.aws_sns_topic_subscription.alarm_email_subscription: Creating...
module.cloudwatch.aws_cloudwatch_metric_alarm.instance_up_overnight: Modifying... [id=instance_up_overnight]
module.cloudwatch.aws_sns_topic_subscription.alarm_email_subscription: Creation complete after 0s [id=arn:aws:sns:us-east-1:572865984595:alarm_topic:3b3e576a-d548-4281-aa13-79466a9c86da]
module.lambda.aws_sns_topic_subscription.email_subscription: Creation complete after 0s [id=arn:aws:sns:us-east-1:572865984595:billing_alerts:42899fe3-3a31-4099-97e9-633b1d6cc167]
module.cloudwatch.aws_cloudwatch_metric_alarm.instance_up_overnight: Modifications complete after 1s [id=instance_up_overnight]

Apply complete! Resources: 4 added, 1 changed, 0 destroyed.

Outputs:

ami_id = "ami-0eae9df081ed81260"
autoscaling_group_id = "terraform-20240712062044974000000002"
cloudwatch_alarm_arn = "arn:aws:cloudwatch:us-east-1:572865984595:alarm:instance_up_overnight"
instance_id = "i-0d21564fc91b7a854"
lambda_function_arn = "arn:aws:lambda:us-east-1:572865984595:function:billing_alert"
security_group_id = "sg-07b4b0b3ccb181ea0"
subnet_id = "subnet-0aeedc0b3763d51b8"
vpc_id = "vpc-0bc9256fe76f2d6ef"                                          
