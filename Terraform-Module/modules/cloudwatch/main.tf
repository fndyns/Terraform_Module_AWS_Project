# Create a CloudWatch metric alarm
resource "aws_cloudwatch_metric_alarm" "instance_up_overnight" {
  alarm_name                = var.alarm_name             # Name of the alarm
  comparison_operator       = "GreaterThanThreshold"     # Comparison operator to use for the alarm
  evaluation_periods        = 1                          # Number of periods to evaluate
  metric_name               = "CPUUtilization"           # Metric to monitor
  namespace                 = "AWS/EC2"                  # Namespace of the metric
  period                    = 86400                      # Period in seconds over which the statistic is applied
  statistic                 = "Average"                  # Statistic to apply to the metric
  threshold                 = 1                          # Threshold value to trigger the alarm
  alarm_description         = "Triggered if instance stays up overnight"  # Description of the alarm
  actions_enabled           = true                       # Enable actions when the alarm state is triggered
  alarm_actions             = [aws_sns_topic.alarm_topic.arn]  # SNS topic to notify when the alarm state is triggered

  dimensions = {
    InstanceId = var.instance_id  # Dimension to apply to the metric
  }

  treat_missing_data = "missing"  # How to treat missing data points
}

# Create an SNS topic for alarm notifications
resource "aws_sns_topic" "alarm_topic" {
  name = "alarm_topic"  # Name of the SNS topic
}

# Subscribe an email address to the SNS topic for alarm notifications
resource "aws_sns_topic_subscription" "alarm_email_subscription" {
  topic_arn = aws_sns_topic.alarm_topic.arn  # ARN of the SNS topic
  protocol  = "email"                        # Protocol to use for the subscription
  endpoint  = var.alarm_email                # Email address to receive notifications
}

