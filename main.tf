provider "aws" {
  region  = var.region
  profile = var.profile
}

# Instance
data "aws_ami" "this" {
  most_recent = true

  filter {
    name   = "name"
    values = ["matillion-etl-for-snowflake-ami-1.42.*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["aws-marketplace"]
}

data "template_file" "this" {
  template = file("${path.module}/files/user_data.tpl")
  vars = {
    region    = var.region
    log_group = var.matillion_log_group
  }
}

resource "aws_instance" "this" {
  ami             = data.aws_ami.this.id
  instance_type   = var.instance_type
  security_groups = [aws_security_group.this_instance.id]
  subnet_id       = var.public_subnet_ids[0]
  user_data       = data.template_file.this.rendered
}

resource "aws_security_group" "this_instance" {
  description = "Allow traffic from ALB"

  ingress {
    description     = "Allow HTTP from ALB"
    from_port       = 80
    protocol        = "tcp"
    to_port         = 80
    security_groups = merge(var.matillion_sg_ids, [aws_security_group.this_alb.id])
  }

  ingress {
    description     = "Allow HTTPS from ALB"
    from_port       = 443
    protocol        = "tcp"
    to_port         = 443
    security_groups = merge(var.matillion_sg_ids, [aws_security_group.this_alb.id])
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Load balancer
resource "aws_alb" "this" {
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnet_ids
  security_groups    = [aws_security_group.this_alb.id]
}

resource "aws_alb_target_group" "this" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_alb_target_group_attachment" "this" {
  target_group_arn = aws_alb_target_group.this.arn
  target_id        = aws_instance.this.id
  port             = 80
  depends_on       = [aws_instance.this]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_alb_listener" "this" {
  load_balancer_arn = aws_alb.this.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.this.arn
  }
}

resource "aws_security_group" "this_alb" {
  description = "Allow ALB traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = var.whitelist_ips
  }

  ingress {
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
    cidr_blocks = var.whitelist_ips
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
