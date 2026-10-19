# ---------------------------------------------------------
# Application Auto Scaling Group
# ---------------------------------------------------------

resource "aws_autoscaling_group" "app" {



  name = "${var.project_name}-app-asg"

  min_size         = 2
  desired_capacity = 2
  max_size         = 4

  wait_for_capacity_timeout = "20m"

  metrics_granularity = "1Minute"

  enabled_metrics = [
    "GroupInServiceInstances"
  ]


  vpc_zone_identifier = [
    aws_subnet.app_private_1.id,
    aws_subnet.app_private_2.id
  ]

  target_group_arns = [
    aws_lb_target_group.app.arn
  ]

  health_check_type         = "ELB"
  health_check_grace_period = 600

  launch_template {
    id      = aws_launch_template.app.id
    version = aws_launch_template.app.latest_version
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-app"
    propagate_at_launch = true
  }

  tag {
    key                 = "Tier"
    value               = "Application"
    propagate_at_launch = true
  }

  tag {
    key                 = "ManagedBy"
    value               = "Terraform"
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = "Project02"
    propagate_at_launch = true
  }

  depends_on = [
    aws_lb_listener.http
  ]
}