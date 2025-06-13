# modules/alb/variables.tf
variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "public_subnet_ids" {
  description = "IDs of the public subnets for ALB"
  type        = list(string)
}

variable "alb_sg_id" {
  description = "ID of the ALB security group"
  type        = string
}

variable "web_app_asg_name" {
  description = "Name of the Web App Auto Scaling Group to attach"
  type        = string
}

variable "bi_tool_instance_id" {
  description = "ID of the BI Tool EC2 instance to attach"
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

variable "app_cert_arn" {
  description = "ARN of the ACM certificate for the app domain"
  type        = string
}

variable "bi_tool_cert_arn" {
  description = "ARN of the ACM certificate for the BI tool domain"
  type        = string
}

variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
}

variable "project_name" {
  description = "A unique name for the project to tag resources"
  type        = string
}