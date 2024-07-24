# Variable for the name of the Lambda function
variable "lambda_function_name" {
  description = "Name of the Lambda function"  # Describes the purpose of this variable
  type        = string  # Specifies that the value of this variable should be a string
}

# Variable for the name of the Lambda execution role
variable "lambda_role_name" {
  description = "Name of the Lambda execution role"  # Describes the purpose of this variable
  type        = string  # Specifies that the value of this variable should be a string
}

# Variable for the name of the Lambda policy
variable "lambda_policy_name" {
  description = "Name of the Lambda policy"  # Describes the purpose of this variable
  type        = string  # Specifies that the value of this variable should be a string
}

# Variable for the name of the CloudWatch event rule
variable "cloudwatch_event_rule_name" {
  description = "Name of the CloudWatch event rule"  # Describes the purpose of this variable
  type        = string  # Specifies that the value of this variable should be a string
}

# Variable for the email address to receive billing alerts
variable "billing_alert_email" {
  description = "Email address for billing alerts"  # Describes the purpose of this variable
  type        = string  # Specifies that the value of this variable should be a string
}

