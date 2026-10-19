output "aws_region" {
  description = "AWS region used by Project 02"
  value       = var.aws_region
}

output "project_name" {
  description = "Project 02 resource name prefix"
  value       = var.project_name
}

output "vpc_id" {
  description = "Project 02 VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id
  ]
}

output "app_private_subnet_ids" {
  description = "Application private subnet IDs"
  value = [
    aws_subnet.app_private_1.id,
    aws_subnet.app_private_2.id
  ]
}

output "db_private_subnet_ids" {
  description = "Database private subnet IDs"
  value = [
    aws_subnet.db_private_1.id,
    aws_subnet.db_private_2.id
  ]
}

output "nat_gateway_id" {
  description = "NAT Gateway ID"
  value       = aws_nat_gateway.main.id
}

output "nat_public_ip" {
  description = "Public Elastic IP assigned to the NAT Gateway"
  value       = aws_eip.nat.public_ip
}

output "alb_security_group_id" {
  description = "Security group ID for the Application Load Balancer"
  value       = aws_security_group.alb.id
}

output "app_security_group_id" {
  description = "Security group ID for the application EC2 instances"
  value       = aws_security_group.app.id
}

output "db_security_group_id" {
  description = "Security group ID for the RDS database"
  value       = aws_security_group.db.id
}

output "app_ec2_iam_role_name" {
  description = "IAM role used by Project 02 application EC2 instances"
  value       = aws_iam_role.app_ec2.name
}

output "app_ec2_instance_profile_name" {
  description = "IAM instance profile used by Project 02 application EC2 instances"
  value       = aws_iam_instance_profile.app_ec2.name
}

output "rds_instance_identifier" {
  description = "RDS MySQL instance identifier"
  value       = aws_db_instance.app.identifier
}

output "rds_endpoint" {
  description = "RDS MySQL endpoint"
  value       = aws_db_instance.app.address
}

output "rds_port" {
  description = "RDS MySQL port"
  value       = aws_db_instance.app.port
}

output "rds_database_name" {
  description = "Initial application database"
  value       = var.db_name
}

output "rds_master_secret_arn" {
  description = "Secrets Manager ARN containing the RDS master credentials"
  value       = aws_db_instance.app.master_user_secret[0].secret_arn
}

output "app_launch_template_id" {
  description = "Application EC2 Launch Template ID"
  value       = aws_launch_template.app.id
}

output "app_launch_template_latest_version" {
  description = "Latest application Launch Template version"
  value       = aws_launch_template.app.latest_version
}

output "app_ami_id" {
  description = "Pinned Ubuntu AMI used by application instances"
  value       = var.app_ami_id
}

output "alb_dns_name" {
  description = "Public DNS name of the Application Load Balancer"
  value       = aws_lb.app.dns_name
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.app.arn
}

output "target_group_arn" {
  description = "ARN of the application target group"
  value       = aws_lb_target_group.app.arn
}

output "autoscaling_group_name" {
  description = "Name of the application Auto Scaling Group"
  value       = aws_autoscaling_group.app.name
}

output "route53_name_servers" {
  description = "Route 53 authoritative name servers for ahkashcloud.com"
  value       = aws_route53_zone.primary.name_servers
}

output "application_url" {
  description = "HTTPS URL for Project 02"
  value       = "https://ahkashcloud.com/LoginWebApp/"
}

output "acm_certificate_arn" {
  description = "ACM certificate used by the HTTPS listener"
  value       = aws_acm_certificate.app.arn
}

output "monitoring_sns_topic_arn" {
  description = "SNS topic used by Project 02 CloudWatch alarms"
  value       = aws_sns_topic.monitoring.arn
}

output "cloudwatch_alarm_names" {
  description = "Project 02 CloudWatch monitoring alarms"

  value = [
    aws_cloudwatch_metric_alarm.alb_unhealthy_targets.alarm_name,
    aws_cloudwatch_metric_alarm.asg_low_capacity.alarm_name,
    aws_cloudwatch_metric_alarm.rds_high_cpu.alarm_name
  ]
}