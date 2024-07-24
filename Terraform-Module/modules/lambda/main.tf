# Create an IAM role for the Lambda function
resource "aws_iam_role" "lambda_exec_role" {
  name = var.lambda_role_name  # Name of the IAM role

  # Define the policy that allows Lambda to assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",  # Action that allows assuming the role
      Effect = "Allow",           # Allow the action
      Sid    = "",
      Principal = {
        Service = "lambda.amazonaws.com",  # Lambda service is allowed to assume this role
      },
    }],
  })
}

# Attach a policy to the IAM role
resource "aws_iam_role_policy" "lambda_policy" {
  name   = var.lambda_policy_name           # Name of the IAM policy
  role   = aws_iam_role.lambda_exec_role.id # ID of the IAM role
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "logs:*",                        # Allow all CloudWatch Logs actions
          "sns:Publish",                   # Allow SNS publish action
          "ec2:DescribeInstances",         # Allow describing EC2 instances
          "cloudwatch:GetMetricStatistics" # Allow getting CloudWatch metric statistics
        ],
        Effect   = "Allow",  # Allow these actions
        Resource = "*",      # On all resources
      },
    ],
  })
}

# Create an SNS topic for billing alerts
resource "aws_sns_topic" "billing_alerts" {
  name = "billing_alerts"  # Name of the SNS topic
}

# Subscribe an email endpoint to the SNS topic
resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.billing_alerts.arn # ARN of the SNS topic
  protocol  = "email"                           # Protocol for the subscription
  endpoint  = var.billing_alert_email           # Email endpoint for the subscription
}

# Create the Lambda function
resource "aws_lambda_function" "billing_alert" {
  filename         = "${path.module}/lambda.zip"                   # Path to the deployment package
  function_name    = var.lambda_function_name                      # Name of the Lambda function
  role             = aws_iam_role.lambda_exec_role.arn             # ARN of the IAM role
  handler          = "lambda_function.lambda_handler"              # Function handler
  runtime          = "python3.8"                                   # Runtime environment
  source_code_hash = filebase64sha256("${path.module}/lambda.zip") # Hash of the source code
}

# Allow CloudWatch to invoke the Lambda function
resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"       # Identifier for the permission statement
  action        = "lambda:InvokeFunction"              # Action to allow
  function_name = aws_lambda_function.billing_alert.arn # ARN of the Lambda function
  principal     = "events.amazonaws.com"               # Principal that is allowed to invoke the function
}

# Create a CloudWatch event rule to trigger the Lambda function on EC2 termination
resource "aws_cloudwatch_event_rule" "ec2_termination_rule" {
  name        = var.cloudwatch_event_rule_name           # Name of the event rule
  description = "Trigger Lambda on EC2 termination"      # Description of the event rule

  # Define the event pattern that triggers the rule
  event_pattern = jsonencode({
    source = ["aws.ec2"],                                 # Source of the event
    "detail-type" = ["EC2 Instance State-change Notification"], # Detail type of the event
    detail = {
      state = ["terminated"]                              # Detail state that triggers the event
    },
  })
}

# Set the Lambda function as the target for the CloudWatch event rule
resource "aws_cloudwatch_event_target" "ec2_termination_target" {
  rule      = aws_cloudwatch_event_rule.ec2_termination_rule.name # Name of the event rule
  target_id = "send_billing_report"                              # Target ID
  arn       = aws_lambda_function.billing_alert.arn              # ARN of the Lambda function
}

