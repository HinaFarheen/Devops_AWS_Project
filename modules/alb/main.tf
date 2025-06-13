# modules/alb/main.tf
resource "aws_lb" "main" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnet_ids
  tags = {
    Name    = "${var.project_name}-alb"
    Project = var.project_name
  }
}

resource "aws_lb_target_group" "web_app_tg" {
  name     = "${var.project_name}-web-app-tg"
  port     = 80 # Nginx port on EC2 instances
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    path = "/"
    protocol = "HTTP"
    interval = 30
    timeout = 5
    healthy_threshold = 2
    unhealthy_threshold = 2
    matcher = "200-399"
  }
  tags = {
    Name    = "${var.project_name}-web-app-tg"
    Project = var.project_name
  }
}

resource "aws_lb_target_group" "bi_tool_tg" {
  name     = "${var.project_name}-bi-tool-tg"
  port     = 3000 # Metabase port on EC2
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    path = "/"
    protocol = "HTTP"
    interval = 30
    timeout = 5
    healthy_threshold = 2
    unhealthy_threshold = 2
    matcher = "200-399"
  }
  tags = {
    Name    = "${var.project_name}-bi-tool-tg"
    Project = var.project_name
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.main.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  # Default certificate for the listener (e.g., the app cert)
  certificate_arn   = var.app_cert_arn
  default_action {
    type             = "fixed-response" # Placeholder default, overridden by rules
    fixed_response {
      content_type = "text/plain"
      status_code  = "404"
      message_body = "Not Found"
    }
  }
}

# Attach additional certificates for SNI (e.g., BI tool cert)
resource "aws_lb_listener_certificate" "bi_tool_listener_cert" {
  listener_arn    = aws_lb_listener.https.arn
  certificate_arn = var.bi_tool_cert_arn
}

resource "aws_lb_listener_rule" "web_app_rule" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_app_tg.arn
  }

  condition {
    host_header {
      values = [var.app_domain_name]
    }
  }
}

resource "aws_lb_listener_rule" "bi_tool_rule" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 200

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.bi_tool_tg.arn
  }

  condition {
    host_header {
      values = [var.bi_tool_domain_name]
    }
  }
}

# Attach ASG to Web App Target Group
resource "aws_autoscaling_attachment" "web_app_asg_attachment" {
  autoscaling_group_name = var.web_app_asg_name
  lb_target_group_arn    = aws_lb_target_group.web_app_tg.arn
}

# Attach BI Tool Instance to BI Tool Target Group
resource "aws_lb_target_group_attachment" "bi_tool_attachment" {
  target_group_arn = aws_lb_target_group.bi_tool_tg.arn
  target_id        = var.bi_tool_instance_id
  port             = 3000 # The port Metabase listens on on the EC2 instance
}