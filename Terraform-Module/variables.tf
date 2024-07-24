# Variable for the AWS region where resources will be deployed
variable "region" {
  description = "AWS region to deploy resources"  # Description of the variable
  default     = "us-east-1"                       # Default value for the region
}

# Variable for the name of the SSH key pair
variable "key_name" {
  description = "Name of the SSH key pair"  # Description of the variable
  type        = string                      # Type of the variable is string
}

# Variable for the email address to receive billing alerts
variable "billing_alert_email" {
  description = "Email address for billing alerts"  # Description of the variable
  type        = string                              # Type of the variable is string
}

# Variable for the email address to receive alarm notifications
variable "alarm_email" {
  description = "Email address for alarm notifications"  # Description of the variable
  type        = string                                   # Type of the variable is string
}

