# modules/ec2/main.tf
resource "aws_launch_template" "web_app_launch_template" {
  name_prefix   = "${var.project_name}-web-app-lt"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  vpc_security_group_ids = [var.web_app_sg_id]
  # Pass user_data content and variables to the script
  user_data     = base64encode(templatefile("${path.module}/../../user_data_web_app.sh", {
    github_repo_url        = var.github_repo_url
    mysql_db_endpoint      = var.mysql_db_endpoint
    mysql_db_name          = var.mysql_db_name
    db_username            = var.db_username
    db_password            = var.db_password
    postgresql_db_endpoint = var.postgresql_db_endpoint
    postgresql_db_name     = var.postgresql_db_name
  }))
  iam_instance_profile {
    name = var.iam_instance_profile_name
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name    = "${var.project_name}-web-app-instance"
      Project = var.project_name
    }
  }
}

resource "aws_autoscaling_group" "web_app_asg" {
  desired_capacity    = 2
  max_size            = 3
  min_size            = 2
  vpc_zone_identifier = var.private_subnet_ids # Instances launched into private subnets
  launch_template {
    id      = aws_launch_template.web_app_launch_template.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "${var.project_name}-web-app-asg-instance"
    propagate_at_launch = true
  }
    tag { # Propagates 'Name' tag to instances
    key                 = "Name"
    value               = "${var.project_name}-web-app-asg-instance"
    propagate_at_launch = true
  }
  tag { # Propagates 'Project' tag to instances (another singular 'tag' block)
    key                 = "Project"
    value               = var.project_name
    propagate_at_launch = true
  }
}

resource "aws_eip" "bi_tool_eip" {

  tags = {
    Name    = "${var.project_name}-bi-tool-eip"
    Project = var.project_name
  }
}

resource "aws_instance" "bi_tool_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.public_subnet_id # Place BI tool in a public subnet for ALB target group access
  vpc_security_group_ids = [var.bi_tool_sg_id]
  associate_public_ip_address = true # Needed since it's in public subnet and directly accessed by ALB
  # Pass user_data content and variables to the script
  user_data     = base64encode(templatefile("${path.module}/../../user_data_bi_tool.sh", {
    db_type      = "postgresql"
    db_endpoint  = var.postgresql_db_endpoint
    db_name      = var.postgresql_db_name
    db_username  = var.db_username
    db_password  = var.db_password
  }))
  iam_instance_profile = var.iam_instance_profile_name
  tags = {
    Name    = "${var.project_name}-bi-tool-instance"
    Project = var.project_name
  }
}