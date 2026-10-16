data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type = "Service"

      identifiers = [
        "ec2.amazonaws.com"
      ]
    }

    actions = [
      "sts:AssumeRole"
    ]
  }
}


# ---------------------------------------------------------
# IAM Role for Application EC2 Instances
# ---------------------------------------------------------

resource "aws_iam_role" "app_ec2" {
  name = "${var.project_name}-app-ec2-role"

  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  tags = {
    Name = "${var.project_name}-app-ec2-role"
    Tier = "Application"
  }
}


# ---------------------------------------------------------
# Systems Manager Permissions
# ---------------------------------------------------------

resource "aws_iam_role_policy_attachment" "app_ssm" {
  role = aws_iam_role.app_ec2.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


# ---------------------------------------------------------
# EC2 Instance Profile
# ---------------------------------------------------------

resource "aws_iam_instance_profile" "app_ec2" {
  name = "${var.project_name}-app-ec2-profile"
  role = aws_iam_role.app_ec2.name

  tags = {
    Name = "${var.project_name}-app-ec2-profile"
    Tier = "Application"
  }
}

# ---------------------------------------------------------
# Application access to the RDS master credential secret
# ---------------------------------------------------------

data "aws_iam_policy_document" "app_db_secret" {
  statement {
    effect = "Allow"

    actions = [
      "secretsmanager:GetSecretValue"
    ]

    resources = [
      aws_db_instance.app.master_user_secret[0].secret_arn
    ]
  }
}

resource "aws_iam_role_policy" "app_db_secret" {
  name = "${var.project_name}-db-secret-access"
  role = aws_iam_role.app_ec2.id

  policy = data.aws_iam_policy_document.app_db_secret.json
}