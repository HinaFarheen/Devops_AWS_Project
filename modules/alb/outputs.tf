# modules/alb/outputs.tf
output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = aws_lb.main.dns_name
}

output "alb_zone_id" {
  description = "The Route 53 Hosted Zone ID of the ALB"
  value       = aws_lb.main.zone_id
}