resource "aws_acm_certificate" "app" {
  domain_name       = "ahkashcloud.com"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "ahkashcloud.com"
  }
}
resource "aws_route53_record" "app" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "ahkashcloud.com"
  type    = "A"

  alias {
    name                   = aws_lb.app.dns_name
    zone_id                = aws_lb.app.zone_id
    evaluate_target_health = true
  }
}