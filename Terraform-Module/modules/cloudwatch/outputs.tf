# Output the ARN of the CloudWatch alarm
output "cloudwatch_alarm_arn" {
  value = aws_cloudwatch_metric_alarm.instance_up_overnight.arn  # The ARN of the created CloudWatch alarm
}

