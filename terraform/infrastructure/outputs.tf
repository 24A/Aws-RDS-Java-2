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