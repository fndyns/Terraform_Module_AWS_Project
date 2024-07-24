# Output the ARN of the Lambda function
output "lambda_function_arn" {
  value = aws_lambda_function.billing_alert.arn  # The ARN of the created Lambda function
}

