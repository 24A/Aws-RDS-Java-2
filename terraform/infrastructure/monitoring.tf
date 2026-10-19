# ---------------------------------------------------------
# SNS Monitoring Topic
# ---------------------------------------------------------

resource "aws_sns_topic" "monitoring" {
  name = "${var.project_name}-monitoring"

  tags = {
    Name = "${var.project_name}-monitoring"
  }
}


# ---------------------------------------------------------
# Email Subscription
# ---------------------------------------------------------

resource "aws_sns_topic_subscription" "monitoring_email" {
  topic_arn = aws_sns_topic.monitoring.arn
  protocol  = "email"
  endpoint  = var.notification_email
}


# ---------------------------------------------------------
# ALB Unhealthy Target Alarm
# ---------------------------------------------------------

resource "aws_cloudwatch_metric_alarm" "alb_unhealthy_targets" {
  alarm_name        = "${var.project_name}-alb-unhealthy-targets"
  alarm_description = "Alarm when the ALB target group contains unhealthy application targets"

  namespace   = "AWS/ApplicationELB"
  metric_name = "UnHealthyHostCount"

  statistic = "Maximum"
  period    = 60

  evaluation_periods = 2
  threshold          = 1

  comparison_operator = "GreaterThanOrEqualToThreshold"

  dimensions = {
    LoadBalancer = aws_lb.app.arn_suffix
    TargetGroup  = aws_lb_target_group.app.arn_suffix
  }

  alarm_actions = [
    aws_sns_topic.monitoring.arn
  ]

  ok_actions = [
    aws_sns_topic.monitoring.arn
  ]

  treat_missing_data = "notBreaching"

  tags = {
    Name = "${var.project_name}-alb-unhealthy-targets"
  }
}


# ---------------------------------------------------------
# Auto Scaling Capacity Alarm
# ---------------------------------------------------------

resource "aws_cloudwatch_metric_alarm" "asg_low_capacity" {
  alarm_name        = "${var.project_name}-asg-low-capacity"
  alarm_description = "Alarm when fewer than two application EC2 instances are InService"

  namespace   = "AWS/AutoScaling"
  metric_name = "GroupInServiceInstances"

  statistic = "Minimum"
  period    = 60

  evaluation_periods = 2
  threshold          = 2

  comparison_operator = "LessThanThreshold"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app.name
  }

  alarm_actions = [
    aws_sns_topic.monitoring.arn
  ]

  ok_actions = [
    aws_sns_topic.monitoring.arn
  ]

  treat_missing_data = "breaching"

  tags = {
    Name = "${var.project_name}-asg-low-capacity"
  }
}


# ---------------------------------------------------------
# RDS High CPU Alarm
# ---------------------------------------------------------

resource "aws_cloudwatch_metric_alarm" "rds_high_cpu" {
  alarm_name        = "${var.project_name}-rds-high-cpu"
  alarm_description = "Alarm when RDS CPU utilization remains above 80 percent"

  namespace   = "AWS/RDS"
  metric_name = "CPUUtilization"

  statistic = "Average"
  period    = 300

  evaluation_periods = 2
  threshold          = 80

  comparison_operator = "GreaterThanThreshold"

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.app.identifier
  }

  alarm_actions = [
    aws_sns_topic.monitoring.arn
  ]

  ok_actions = [
    aws_sns_topic.monitoring.arn
  ]

  treat_missing_data = "notBreaching"

  tags = {
    Name = "${var.project_name}-rds-high-cpu"
  }
}