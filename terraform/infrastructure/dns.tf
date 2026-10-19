# ---------------------------------------------------------
# Route 53 Hosted Zone
# ---------------------------------------------------------

resource "aws_route53_zone" "primary" {
  name = "ahkashcloud.com"

  tags = {
    Name = "ahkashcloud.com"
  }
}