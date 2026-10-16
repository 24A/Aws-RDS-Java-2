# ---------------------------------------------------------
# RDS DB Subnet Group
# ---------------------------------------------------------

resource "aws_db_subnet_group" "app" {
  name = "${var.project_name}-db-subnet-group"

  subnet_ids = [
    aws_subnet.db_private_1.id,
    aws_subnet.db_private_2.id
  ]

  tags = {
    Name = "${var.project_name}-db-subnet-group"
    Tier = "Database"
  }
}


# ---------------------------------------------------------
# RDS MySQL Database
# ---------------------------------------------------------

resource "aws_db_instance" "app" {
  identifier = "${var.project_name}-rds"

  engine         = "mysql"
  engine_version = "8.0.46"
  instance_class = var.db_instance_class

  allocated_storage     = var.db_allocated_storage
  max_allocated_storage = 100
  storage_type          = "gp3"
  storage_encrypted     = true

  db_name  = var.db_name
  username = var.db_username
  port     = 3306

  manage_master_user_password = true

  db_subnet_group_name   = aws_db_subnet_group.app.name
  vpc_security_group_ids = [aws_security_group.db.id]

  publicly_accessible = false
  multi_az            = false

  backup_retention_period    = 1
  auto_minor_version_upgrade = true
  copy_tags_to_snapshot      = true

  deletion_protection = false
  skip_final_snapshot = true

  tags = {
    Name = "${var.project_name}-rds"
    Tier = "Database"
  }
}