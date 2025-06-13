# Root main.tf

provider "aws" {
  region = var.aws_region
}

# Data source for your hosted zone in Route 53
data "aws_route53_zone" "selected" {
  name         = var.domain_name
  private_zone = false
}

# Read user data scripts content from the root directory
locals {
  user_data_web_app_script = file("${path.module}/user_data_web_app.sh")
  user_data_bi_tool_script = file("${path.module}/user_data_bi_tool.sh")
}

# --- Module Calls ---

module "vpc" {
  source = "./modules/vpc" # Points to the VPC module directory
  
  # Pass variables required by the VPC module
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  aws_region      = var.aws_region
  project_name    = var.project_name
}

module "security_groups" {
  source = "./modules/security_groups"

  # Pass variables required by the Security Groups module
  vpc_id       = module.vpc.vpc_id # Get VPC ID from VPC module's output
  your_ip      = var.your_ip
  project_name = var.project_name
}

module "rds" {
  source = "./modules/rds"

  # Pass variables required by the RDS module
  vpc_id                 = module.vpc.vpc_id
  private_subnet_ids     = module.vpc.private_subnet_ids # Get private subnet IDs from VPC module
  db_username            = var.db_username
  db_password            = var.db_password
  mysql_db_name          = var.mysql_db_name
  postgresql_db_name     = var.postgresql_db_name
  rds_mysql_sg_id        = module.security_groups.rds_mysql_sg_id # Get SG IDs from Security Groups module
  rds_postgresql_sg_id   = module.security_groups.rds_postgresql_sg_id
  project_name           = var.project_name
}

module "ec2" {
  source = "./modules/ec2"

  # Pass variables required by the EC2 module
  ami_id                    = var.ami_id
  instance_type             = var.instance_type
  key_name                  = var.key_name
  private_subnet_ids        = module.vpc.private_subnet_ids
  public_subnet_id          = module.vpc.public_subnet_ids[0] # Using the first public subnet for BI tool
  web_app_sg_id             = module.security_groups.web_app_sg_id
  bi_tool_sg_id             = module.security_groups.bi_tool_sg_id
  iam_instance_profile_name = module.security_groups.ec2_instance_profile_name # Get IAM profile from Security Groups module
  user_data_web_app         = local.user_data_web_app_script   # Pass content of user data scripts
  user_data_bi_tool         = local.user_data_bi_tool_script
  project_name              = var.project_name
  github_repo_url           = var.github_repo_url # Pass this to user_data scripts
  
  # Pass DB connection details to user_data scripts for Docker Compose .env
  mysql_db_endpoint         = module.rds.mysql_db_endpoint
  mysql_db_name             = module.rds.mysql_db_name
  db_username               = var.db_username
  db_password               = var.db_password
  postgresql_db_endpoint    = module.rds.postgresql_db_endpoint
  postgresql_db_name        = module.rds.postgresql_db_name
}

module "alb" {
  source = "./modules/alb"

  # Pass variables required by the ALB module
  vpc_id                 = module.vpc.vpc_id
  public_subnet_ids      = module.vpc.public_subnet_ids
  alb_sg_id              = module.security_groups.alb_sg_id
  web_app_asg_name       = module.ec2.web_app_asg_name       # Get ASG name from EC2 module
  bi_tool_instance_id    = module.ec2.bi_tool_instance_id    # Get BI tool instance ID from EC2 module
  app_domain_name        = var.app_domain_name
  bi_tool_domain_name    = var.bi_tool_domain_name
  app_cert_arn           = module.dns.app_cert_arn           # Get ACM cert ARNs from DNS module
  bi_tool_cert_arn       = module.dns.bi_tool_cert_arn
  aws_region             = var.aws_region
  project_name           = var.project_name
}

module "dns" {
  source = "./modules/dns"

  # Pass variables required by the DNS module
  domain_name         = var.domain_name
  app_domain_name     = var.app_domain_name
  bi_tool_domain_name = var.bi_tool_domain_name
  alb_zone_id         = module.alb.alb_zone_id              # Get ALB Zone ID from ALB module
  alb_dns_name        = module.alb.alb_dns_name             # Get ALB DNS name from ALB module
  hosted_zone_id      = data.aws_route53_zone.selected.zone_id # Get Hosted Zone ID from data source
  aws_region          = var.aws_region # For ACM validation
  project_name        = var.project_name
}