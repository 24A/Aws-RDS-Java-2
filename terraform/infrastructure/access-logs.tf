# ---------------------------------------------------------
# Current AWS Account
# ---------------------------------------------------------

data "aws_caller_identity" "current" {}


# ---------------------------------------------------------
# S3 Bucket for ALB Access Logs
# ---------------------------------------------------------

resource "aws_s3_bucket" "alb_logs" {
  bucket = "${var.project_name}-alb-logs-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name    = "${var.project_name}-alb-logs"
    Purpose = "ALB Access Logs"
  }
}


# ---------------------------------------------------------
# Block All Public Access
# ---------------------------------------------------------

resource "aws_s3_bucket_public_access_block" "alb_logs" {
  bucket = aws_s3_bucket.alb_logs.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}


# ---------------------------------------------------------
# SSE-S3 Encryption
# ---------------------------------------------------------

resource "aws_s3_bucket_server_side_encryption_configuration" "alb_logs" {
  bucket = aws_s3_bucket.alb_logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


# ---------------------------------------------------------
# Automatically Delete Old Logs After 30 Days
# ---------------------------------------------------------

resource "aws_s3_bucket_lifecycle_configuration" "alb_logs" {
  bucket = aws_s3_bucket.alb_logs.id

  rule {
    id     = "delete-old-alb-logs"
    status = "Enabled"

    filter {
      prefix = "alb/"
    }

    expiration {
      days = 30
    }
  }
}


# ---------------------------------------------------------
# Allow AWS ELB Log Delivery Service to Write Logs
# ---------------------------------------------------------

resource "aws_s3_bucket_policy" "alb_logs" {
  bucket = aws_s3_bucket.alb_logs.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "AllowALBLogDelivery"
        Effect = "Allow"

        Principal = {
          Service = "logdelivery.elasticloadbalancing.amazonaws.com"
        }

        Action = "s3:PutObject"

        Resource = "${aws_s3_bucket.alb_logs.arn}/alb/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
      }
    ]
  })
}