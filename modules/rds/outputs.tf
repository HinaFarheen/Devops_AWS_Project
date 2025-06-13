# modules/rds/outputs.tf
output "mysql_db_endpoint" {
  description = "The endpoint of the MySQL RDS instance"
  value       = aws_db_instance.mysql_db.address
}

output "mysql_db_name" {
  description = "The name of the MySQL database"
  value       = aws_db_instance.mysql_db.db_name
}

output "postgresql_db_endpoint" {
  description = "The endpoint of the PostgreSQL RDS instance"
  value       = aws_db_instance.postgresql_db.address
}

output "postgresql_db_name" {
  description = "The name of the PostgreSQL database"
  value       = aws_db_instance.postgresql_db.db_name
}