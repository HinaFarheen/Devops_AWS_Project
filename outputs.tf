# Root outputs.tf

output "web_app_url" {
  description = "The URL of the web application"
  value       = "https://${var.app_domain_name}"
}

output "bi_tool_url" {
  description = "The URL of the BI tool (Metabase)"
  value       = "https://${var.bi_tool_domain_name}"
}

output "mysql_db_endpoint" {
  description = "The endpoint of the MySQL RDS instance"
  value       = module.rds.mysql_db_endpoint
}

output "postgresql_db_endpoint" {
  description = "The endpoint of the PostgreSQL RDS instance"
  value       = module.rds.postgresql_db_endpoint
}