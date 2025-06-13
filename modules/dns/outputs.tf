# modules/dns/outputs.tf
output "app_cert_arn" {
  description = "ARN of the ACM certificate for the app domain"
  value       = aws_acm_certificate_validation.app_cert_validation.certificate_arn
}

output "bi_tool_cert_arn" {
  description = "ARN of the ACM certificate for the BI tool domain"
  value       = aws_acm_certificate_validation.bi_tool_cert_validation.certificate_arn
}