

# Application Load Balancer
resource "aws_lb" "clops_alb" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group_id]
  subnets            = var.alb_subnet_ids

  tags = {
    Name = var.alb_name
  }
}

/*# Define the ALB security group
resource "aws_security_group" "alb_sg" {
  vpc_id = var.vpc_id  # Use the variable for vpc_id passed from the root module
  name   = "alb-sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Open to all, adjust as needed
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-sg"
  }
}
*/





# Target Group
resource "aws_lb_target_group" "clops_target_group" {
  name        = var.target_group_name
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = {
    Name = var.target_group_name
  }
}


# Adding instances to the target group
resource "aws_lb_target_group_attachment" "app_server_1" {
  target_group_arn = aws_lb_target_group.clops_target_group.arn
  target_id        = var.private_server_1_id  
  port             = 80
}

resource "aws_lb_target_group_attachment" "app_server_2" {
  target_group_arn = aws_lb_target_group.clops_target_group.arn
  target_id        = var.private_server_2_id  
  port             = 80
}


# Listener for ALB
resource "aws_lb_listener" "clops_listener" {
  load_balancer_arn = aws_lb.clops_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.clops_target_group.arn
  }
}
