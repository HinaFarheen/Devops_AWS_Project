# modules/rds/main.tf
resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.private_subnet_ids
  tags = {
    Name    = "${var.project_name}-db-subnet-group"
    Project = var.project_name
  }
}

resource "aws_db_instance" "mysql_db" {
  identifier           = "${var.project_name}-mysql-db"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0.35"
  instance_class       = "db.t3.micro"
  db_name                 = var.mysql_db_name
  username             = var.db_username
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.rds_mysql_sg_id]
  multi_az             = true
  skip_final_snapshot  = true # Set to false in production
  publicly_accessible  = false
  tags = {
    Name    = "${var.project_name}-mysql-db"
    Project = var.project_name
  }
}

resource "aws_db_instance" "postgresql_db" {
  identifier           = "${var.project_name}-postgresql-db"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "17.1"
  instance_class       = "db.t3.micro"
  db_name                 = var.postgresql_db_name
  username             = var.db_username
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.rds_postgresql_sg_id]
  multi_az             = true
  skip_final_snapshot  = true # Set to false in production
  publicly_accessible  = false
  tags = {
    Name    = "${var.project_name}-postgresql-db"
    Project = var.project_name
  }
}