# Output the ID of the auto-scaling group
output "autoscaling_group_id" {
  value = aws_autoscaling_group.asg.id  # The ID of the created auto-scaling group
}

