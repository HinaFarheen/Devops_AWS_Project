# Root variables.tf

variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "eu-north-1"
}

variable "project_name" {
  description = "A unique name for the project to tag resources"
  type        = string
  default     = "hina-cloud-project"
}

variable "domain_name" {
  description = "Your registered domain name in Route 53"
  type        = string
  default     = "codelessops.site" 
}

variable "app_domain_name" {
  description = "Subdomain for the web application"
  type        = string
  default     = "hina-app.codelessops.site" 
}

variable "bi_tool_domain_name" {
  description = "Subdomain for the BI tool"
  type        = string
  default     = "hina-bi.codelessops.site" 
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  description = "List of private subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "your_ip" {
  description = "Your public IP address for SSH access (e.g., 'X.X.X.X/32')"
  type        = string
  default     = "101.53.224.48/32" # IMPORTANT: For production, narrow this to your actual IP
}

variable "db_username" {
  description = "Username for RDS databases"
  type        = string
  default     = "hina_rds_db"
}

variable "db_password" {
  description = "Password for RDS databases"
  type        = string
  sensitive   = true
  default     = "StrongPass123!" # IMPORTANT: Change this to a strong, unique password!
}

variable "mysql_db_name" {
  description = "Name of the MySQL database"
  type        = string
  default     = "webappdb"
}

variable "postgresql_db_name" {
  description = "Name of the PostgreSQL database"
  type        = string
  default     = "bitool_db"
}

variable "ami_id" {
  description = "AMI ID for EC2 instances (Amazon Linux 2 in eu-north-1)"
  type        = string
  default     = "ami-006b4a3ad5f56fbd6" # Verify latest for your region
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "key_name" {
  description = "Name of the EC2 Key Pair (must exist in AWS)"
  type        = string
  default     = "hina-key" 
}

variable "github_repo_url" {
  description = "URL of your GitHub repository for the web application"
  type        = string
  default     = "https://github.com/HinaFarheen/my_reactapp.git" 
}