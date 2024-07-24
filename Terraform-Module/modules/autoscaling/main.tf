# Create a launch configuration for the auto-scaling group
resource "aws_launch_configuration" "lc" {
  name          = var.launch_config_name  # Name of the launch configuration
  image_id      = var.ami_id  # AMI ID to use for the instances
  instance_type = var.instance_type  # Instance type to use

  # Security groups to associate with the instances
  security_groups = [var.security_group_id]

  # Ensure that a new launch configuration is created before the old one is destroyed
  lifecycle {
    create_before_destroy = true
  }
}

# Create an auto-scaling group
resource "aws_autoscaling_group" "asg" {
  desired_capacity     = 0  # Initial number of instances
  max_size             = 2  # Maximum number of instances
  min_size             = 0  # Minimum number of instances
  launch_configuration = aws_launch_configuration.lc.id  # Launch configuration to use
  vpc_zone_identifier  = [var.subnet_id]  # Subnet to associate with the auto-scaling group

  # Tag to apply to the instances
  tag {
    key                 = "Name"
    value               = var.autoscaling_group_name  # Name for the auto-scaling group
    propagate_at_launch = true  # Propagate the tag to instances at launch
  }
}

# Create a schedule to scale up the auto-scaling group
resource "aws_autoscaling_schedule" "scale_up" {
  scheduled_action_name  = "scale_up_at_6am"  # Name of the scheduled action
  min_size               = 2  # Minimum number of instances
  max_size               = 2  # Maximum number of instances
  desired_capacity       = 2  # Desired number of instances
  recurrence             = "0 6 * * *"  # Cron expression for the schedule (every day at 6 AM)
  autoscaling_group_name = aws_autoscaling_group.asg.name  # Auto-scaling group to apply the schedule to
}

# Create a schedule to scale down the auto-scaling group
resource "aws_autoscaling_schedule" "scale_down" {
  scheduled_action_name  = "scale_down_at 6pm"  # Name of the scheduled action
  min_size               = 0  # Minimum number of instances
  max_size               = 0  # Maximum number of instances
  desired_capacity       = 0  # Desired number of instances
  recurrence             = "0 18 * * *"  # Cron expression for the schedule (every day at 6 PM)
  autoscaling_group_name = aws_autoscaling_group.asg.name  # Auto-scaling group to apply the schedule to
}

