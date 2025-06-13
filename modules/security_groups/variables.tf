# modules/security_groups/variables.tf
variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "your_ip" {
  description = "Your public IP address for SSH access"
  type        = string
}

variable "project_name" {
  description = "A unique name for the project to tag resources"
  type        = string
}