variable "aws_region" {
  description = "AWS region for Project 02"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Prefix used for Project 02 AWS resources"
  type        = string
  default     = "project02-prod"
}

variable "vpc_cidr" {
  description = "CIDR block for the Project 02 VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_1_cidr" {
  description = "CIDR for public subnet in Availability Zone 1"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_2_cidr" {
  description = "CIDR for public subnet in Availability Zone 2"
  type        = string
  default     = "10.0.2.0/24"
}

variable "app_private_subnet_1_cidr" {
  description = "CIDR for application private subnet in Availability Zone 1"
  type        = string
  default     = "10.0.11.0/24"
}

variable "app_private_subnet_2_cidr" {
  description = "CIDR for application private subnet in Availability Zone 2"
  type        = string
  default     = "10.0.12.0/24"
}

variable "db_private_subnet_1_cidr" {
  description = "CIDR for database private subnet in Availability Zone 1"
  type        = string
  default     = "10.0.21.0/24"
}

variable "db_private_subnet_2_cidr" {
  description = "CIDR for database private subnet in Availability Zone 2"
  type        = string
  default     = "10.0.22.0/24"
}

variable "availability_zone_1" {
  description = "Primary Availability Zone for Project 02"
  type        = string
  default     = "us-east-1a"
}

variable "availability_zone_2" {
  description = "Secondary Availability Zone for Project 02"
  type        = string
  default     = "us-east-1b"
}

variable "db_name" {
  description = "Initial MySQL database name"
  type        = string
  default     = "jwt"
}

variable "db_username" {
  description = "RDS master username"
  type        = string
  default     = "admin"
}

variable "db_instance_class" {
  description = "RDS database instance class"
  type        = string
  default     = "db.t4g.micro"
}

variable "db_allocated_storage" {
  description = "Initial RDS allocated storage in GiB"
  type        = number
  default     = 20
}

variable "app_instance_type" {
  description = "EC2 instance type for application servers"
  type        = string
  default     = "t3.micro"
}

variable "application_repository_url" {
  description = "GitHub repository containing the Java web application"
  type        = string
  default     = "https://github.com/24A/Aws-RDS-Java-2.git"
}

variable "application_branch" {
  description = "Git branch deployed to application servers"
  type        = string
  default     = "feat/terraform-infrastructure"
}

variable "app_ami_id" {
  description = "Pinned Ubuntu 22.04 AMI used by the application Launch Template"
  type        = string
  default     = "ami-062944a84867f2386"
}

variable "notification_email" {
  description = "ahkash12@gmail.com"
  type        = string
}