# modules/security_groups/outputs.tf
output "alb_sg_id" {
  description = "ID of the ALB security group"
  value       = aws_security_group.alb_sg.id
}

output "web_app_sg_id" {
  description = "ID of the Web App EC2 security group"
  value       = aws_security_group.web_app_sg.id
}

output "bi_tool_sg_id" {
  description = "ID of the BI Tool EC2 security group"
  value       = aws_security_group.bi_tool_sg.id
}

output "rds_mysql_sg_id" {
  description = "ID of the RDS MySQL security group"
  value       = aws_security_group.rds_mysql_sg.id
}

output "rds_postgresql_sg_id" {
  description = "ID of the RDS PostgreSQL security group"
  value       = aws_security_group.rds_postgresql_sg.id
}

output "ec2_instance_profile_name" {
  description = "Name of the EC2 IAM instance profile"
  value       = aws_iam_instance_profile.ec2_instance_profile.name
}