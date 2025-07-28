# # ➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤
# Note: The ALB sits in the public subnet whose {Route table} has 0.0.0.0/0 → igw
# ➤ Application Load Balancer ➤
resource "aws_lb" "ecs_alb" {
  name               = "ecs-alb"
  internal           = false # Internet Facing! Not Internally!! 
  load_balancer_type = "application" # Application layer. HTTP/HTTPS traffic handling.
  subnets            = [var.public_subnet_us-east-1a_id, var.public_subnet_us-east-1b_id] # Traffic will go to --> Public Subnet
  security_groups    = [aws_security_group.alb_sg.id]
  
  # FindingTag
  # lifecycle {
  #   prevent_destroy = true
  # }
}

# Target Group -- ECS (targetting to router the traffic)
resource "aws_lb_target_group" "alb_target_group" {
  name     = "alb-target-group"
  port     = 8082 # conatiner application run on the PORT 8082 
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  // When using ECS with Fargate, there are no EC2 instance IDs, because:
  // Each Fargate task runs in an isolated container with its own IP.
  // Therefore, ALB must forward traffic to those task IPs directly. 
  target_type = "ip"  #  (needed for Fargate)

  health_check {
    path                = "/health"
    interval            = 30
    timeout             = 5
    unhealthy_threshold = 2 
    healthy_threshold   = 2
    matcher             = "200"
  }
}

# Listener - By default ALB listen at the PORT - 80 
resource "aws_lb_listener" "ecs_listener" {
  load_balancer_arn = aws_lb.ecs_alb.arn
  port              = 80 # by default ALB Listen at PORT 80 !!
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn # If traffic is coming at pot 80 I am forwarding to the ECS(Target Group) 
  }
}

# ➤ Security Groups ALB ➤ Allowing the Traffic from the IG. 
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow inbound HTTP"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # Allow traffic from the Internet!
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Meaning --> every IP protocol number)
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb_sg"
  }
}