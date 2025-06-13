# modules/security_groups/main.tf
resource "aws_security_group" "alb_sg" {
  name        = "${var.project_name}-alb-sg"
  description = "Allow HTTP/HTTPS traffic to ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name    = "${var.project_name}-alb-sg"
    Project = var.project_name
  }
}

resource "aws_security_group" "web_app_sg" {
  name        = "${var.project_name}-web-app-sg"
  description = "Allow HTTP from ALB, SSH from specific IP"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80 # Nginx listening on port 80 (proxies to Docker 8080)
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.your_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name    = "${var.project_name}-web-app-sg"
    Project = var.project_name
  }
}

resource "aws_security_group" "bi_tool_sg" {
  name        = "${var.project_name}-bi-tool-sg"
  description = "Allow HTTP (Metabase port) from ALB, SSH from specific IP"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3000 # Metabase listens on port 3000
    to_port     = 3000
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.your_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name    = "${var.project_name}-bi-tool-sg"
    Project = var.project_name
  }
}

resource "aws_security_group" "rds_mysql_sg" {
  name        = "${var.project_name}-rds-mysql-sg"
  description = "Allow MySQL access from EC2 instances"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.web_app_sg.id, aws_security_group.bi_tool_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name    = "${var.project_name}-rds-mysql-sg"
    Project = var.project_name
  }
}

resource "aws_security_group" "rds_postgresql_sg" {
  name        = "${var.project_name}-rds-postgresql-sg"
  description = "Allow PostgreSQL access from EC2 instances"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [aws_security_group.web_app_sg.id, aws_security_group.bi_tool_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name    = "${var.project_name}-rds-postgresql-sg"
    Project = var.project_name
  }
}

# IAM Role and Profile for EC2 instances (for SSM access and ECR if needed)
resource "aws_iam_role" "ec2_instance_role" {
  name               = "${var.project_name}-ec2-instance-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
  tags = {
    Name    = "${var.project_name}-ec2-instance-role"
    Project = var.project_name
  }
}

resource "aws_iam_role_policy_attachment" "ssm_policy_attachment" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ecr_read_only_policy_attachment" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly" # For Docker images if using ECR
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${var.project_name}-ec2-instance-profile"
  role = aws_iam_role.ec2_instance_role.name
}