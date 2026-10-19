# ---------------------------------------------------------
# Application EC2 Launch Template
# ---------------------------------------------------------

resource "aws_launch_template" "app" {
  name_prefix = "${var.project_name}-app-"

  image_id      = var.app_ami_id
  instance_type = var.app_instance_type

  update_default_version = true

  iam_instance_profile {
    name = aws_iam_instance_profile.app_ec2.name
  }

  vpc_security_group_ids = [
    aws_security_group.app.id
  ]

  user_data = base64encode(
    templatefile(
      "${path.module}/user-data/app.sh.tftpl",
      {
        aws_region        = var.aws_region
        rds_endpoint      = aws_db_instance.app.address
        rds_port          = aws_db_instance.app.port
        db_name           = var.db_name
        rds_secret_arn    = aws_db_instance.app.master_user_secret[0].secret_arn
        repository_url    = var.application_repository_url
        repository_branch = var.application_branch
      }
    )
  )

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size           = 12
      volume_type           = "gp3"
      encrypted             = true
      delete_on_termination = true
    }
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.project_name}-app"
      Tier = "Application"
    }
  }

  tag_specifications {
    resource_type = "volume"

    tags = {
      Name = "${var.project_name}-app-volume"
      Tier = "Application"
    }
  }

  tags = {
    Name = "${var.project_name}-app-launch-template"
    Tier = "Application"
  }
}