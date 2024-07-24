# Variable for the name of the CloudWatch alarm
variable "alarm_name" {
  description = "Name of the CloudWatch alarm"  # Description of the variable
  type        = string  # Type of the variable
}

# Variable for the ARN of the SNS topic to notify
variable "sns_topic_arn" {
  description = "ARN of the SNS topic to notify"  # Description of the variable
  type        = string  # Type of the variable
}

# Variable for the ID of the EC2 instance to monitor
variable "instance_id" {
  description = "ID of the EC2 instance to monitor"  # Description of the variable
  type        = string  # Type of the variable
}

# Variable for the email address for alarm notifications
variable "alarm_email" {
  description = "Email address for alarm notifications"  # Description of the variable
  type        = string  # Type of the variable
}

