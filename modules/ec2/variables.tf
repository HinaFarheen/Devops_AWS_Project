# modules/ec2/variables.tf
variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "Name of the EC2 Key Pair"
  type        = string
}

variable "private_subnet_ids" {
  description = "IDs of the private subnets for ASG"
  type        = list(string)
}

variable "public_subnet_id" {
  description = "ID of a public subnet for the single BI tool instance"
  type        = string
}

variable "web_app_sg_id" {
  description = "ID of the Web App EC2 security group"
  type        = string
}

variable "bi_tool_sg_id" {
  description = "ID of the BI Tool EC2 security group"
  type        = string
}

variable "iam_instance_profile_name" {
  description = "Name of the EC2 IAM instance profile"
  type        = string
}

variable "user_data_web_app" {
  description = "Content of the web app user data script"
  type        = string
}

variable "user_data_bi_tool" {
  description = "Content of the BI tool user data script"
  type        = string
}

variable "project_name" {
  description = "A unique name for the project to tag resources"
  type        = string
}

variable "github_repo_url" {
  description = "URL of your GitHub repository for the web application"
  type        = string
}

# Database variables to pass into user_data scripts for Docker Compose .env or direct docker run
variable "mysql_db_endpoint" {
  description = "Endpoint of the MySQL RDS instance"
  type        = string
}

variable "mysql_db_name" {
  description = "Name of the MySQL database"
  type        = string
}

variable "db_username" {
  description = "Username for RDS databases"
  type        = string
}

variable "db_password" {
  description = "Password for RDS databases"
  type        = string
  sensitive   = true
}

variable "postgresql_db_endpoint" {
  description = "Endpoint of the PostgreSQL RDS instance"
  type        = string
}

variable "postgresql_db_name" {
  description = "Name of the PostgreSQL database"
  type        = string
}