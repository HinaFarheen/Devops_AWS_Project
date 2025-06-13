# modules/dns/main.tf
resource "aws_acm_certificate" "app_cert" {
  domain_name       = var.app_domain_name
  validation_method = "DNS" # Recommended for automation
  tags = {
    Name    = "${var.project_name}-app-cert"
    Project = var.project_name
  }
  lifecycle {
    create_before_destroy = true # Important for re-creation without downtime
  }
}

# Create DNS validation records for the app certificate
resource "aws_route53_record" "app_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.app_cert.domain_validation_options : dvo.domain_name => dvo
  }

  zone_id = var.hosted_zone_id
  name    = each.value.resource_record_name
  type    = each.value.resource_record_type
  records = [each.value.resource_record_value]
  ttl     = 60
}

# Validate the app certificate
resource "aws_acm_certificate_validation" "app_cert_validation" {
  certificate_arn         = aws_acm_certificate.app_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.app_cert_validation : record.fqdn]
}


resource "aws_acm_certificate" "bi_tool_cert" {
  domain_name       = var.bi_tool_domain_name
  validation_method = "DNS"
  tags = {
    Name    = "${var.project_name}-bi-tool-cert"
    Project = var.project_name
  }
  lifecycle {
    create_before_destroy = true
  }
}

# Create DNS validation records for the BI tool certificate
resource "aws_route53_record" "bi_tool_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.bi_tool_cert.domain_validation_options : dvo.domain_name => dvo
  }

  zone_id = var.hosted_zone_id
  name    = each.value.resource_record_name
  type    = each.value.resource_record_type
  records = [each.value.resource_record_value]
  ttl     = 60
}

# Validate the BI tool certificate
resource "aws_acm_certificate_validation" "bi_tool_cert_validation" {
  certificate_arn         = aws_acm_certificate.bi_tool_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.bi_tool_cert_validation : record.fqdn]
}

# Route 53 A record for the web app
resource "aws_route53_record" "app_dns_record" {
  zone_id = var.hosted_zone_id
  name    = var.app_domain_name
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

# Route 53 A record for the BI tool
resource "aws_route53_record" "bi_tool_dns_record" {
  zone_id = var.hosted_zone_id
  name    = var.bi_tool_domain_name
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}