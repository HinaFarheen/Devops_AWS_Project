# modules/ec2/outputs.tf
output "web_app_asg_name" {
  description = "Name of the Web App Auto Scaling Group"
  value       = aws_autoscaling_group.web_app_asg.name
}

output "bi_tool_instance_id" {
  description = "ID of the BI Tool EC2 instance"
  value       = aws_instance.bi_tool_instance.id
}