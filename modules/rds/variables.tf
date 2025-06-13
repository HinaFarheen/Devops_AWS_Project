# modules/rds/variables.tf
variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "private_subnet_ids" {
  description = "IDs of the private subnets for the DB subnet group"
  type        = list(string)
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

variable "mysql_db_name" {
  description = "Name of the MySQL database"
  type        = string
}

variable "postgresql_db_name" {
  description = "Name of the PostgreSQL database"
  type        = string
}

variable "rds_mysql_sg_id" {
  description = "ID of the RDS MySQL security group"
  type        = string
}

variable "rds_postgresql_sg_id" {
  description = "ID of the RDS PostgreSQL security group"
  type        = string
}

variable "project_name" {
  description = "A unique name for the project to tag resources"
  type        = string
}