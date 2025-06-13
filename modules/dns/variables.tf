# modules/dns/variables.tf
variable "domain_name" {
  description = "Your registered domain name in Route 53"
  type        = string
}

variable "app_domain_name" {
  description = "Subdomain for the web application"
  type        = string
}

variable "bi_tool_domain_name" {
  description = "Subdomain for the BI tool"
  type        = string
}

variable "alb_zone_id" {
  description = "The Route 53 Hosted Zone ID of the ALB"
  type        = string
}

variable "alb_dns_name" {
  description = "The DNS name of the ALB"
  type        = string
}

variable "hosted_zone_id" {
  description = "The ID of the Route 53 Hosted Zone for the domain"
  type        = string
}

variable "aws_region" {
  description = "AWS region for ACM certificate validation"
  type        = string
}

variable "project_name" {
  description = "A unique name for the project to tag resources"
  type        = string
}