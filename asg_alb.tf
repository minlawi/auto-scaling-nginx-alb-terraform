# # # 1. Create Launch Template
resource "aws_launch_template" "nginx_lt" {
  count         = var.create_vpc ? 1 : 0
  name          = "nginx-lt"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = local.server_t2_micro
  # key_name               = var.create_bastion ? aws_key_pair.public_key[0].key_name : null
  vpc_security_group_ids = [aws_security_group.nginx_sg[0].id]
  user_data              = filebase64("${path.root}/scripts/nginx-install.sh")

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "nginx-instance"
    }
  }
}

# # # # 2. Create Auto Scaling Group
resource "aws_autoscaling_group" "nginx_asg" {
  count            = var.create_vpc ? 1 : 0
  desired_capacity = 2
  max_size         = 4
  min_size         = 1
  launch_template {
    id      = aws_launch_template.nginx_lt[0].id
    version = "$Latest"
  }
  vpc_zone_identifier       = aws_subnet.private_subnet[*].id
  target_group_arns         = [aws_lb_target_group.app_tg[0].arn]
  health_check_type         = "ELB" // EC2 or ELB
  health_check_grace_period = 300
  force_delete              = true
}

# # # 3. Create Target Group
resource "aws_lb_target_group" "app_tg" {
  count       = var.create_vpc ? 1 : 0
  name        = "nginx-tg"
  port        = local.http_port
  protocol    = local.http_protocol
  vpc_id      = aws_vpc.nginx_vpc[0].id
  target_type = "instance"
  tags = {
    name = "nginx-tg"
  }
  health_check {
    interval            = 30                  // ALB performs health checks every 30 seconds
    path                = "/"                 // Health check path
    port                = local.http_port     // Health check port
    protocol            = local.http_protocol // Health check protocol
    timeout             = 5                   // Health check timeout     
    healthy_threshold   = 2                   // Number of consecutive successful health checks required before considering the target healthy
    unhealthy_threshold = 2                   // Number of consecutive failed health checks required before considering the target unhealthy
    matcher             = "200"               // HTTP code to expect in the response from the target
  }
}

# # 4. Register Targets // This is not needed as we are using ASG
# resource "aws_lb_target_group_attachment" "tg_attachment" {
#   count            = var.create_vpc ? length(aws_instance.nginx_instances) : 0
#   target_group_arn = aws_lb_target_group.app_tg[0].arn
#   target_id        = aws_instance.nginx_instances[count.index].id
#   port             = local.http_port
# }

# # # 5. Create Application Load Balancer
resource "aws_alb" "app_lb" {
  count                      = var.create_vpc ? 1 : 0
  load_balancer_type         = "application"
  name                       = "nginx-alb"
  internal                   = false
  security_groups            = [aws_security_group.alb_sg[0].id]
  subnets                    = aws_subnet.public_subnet[*].id
  enable_deletion_protection = false
  tags = {
    name = "nginx-alb"
  }
}

# # # 6. Create Listener
resource "aws_lb_listener" "listener" {
  count             = var.create_vpc ? 1 : 0
  load_balancer_arn = aws_alb.app_lb[0].arn
  port              = local.http_port
  protocol          = local.http_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg[0].arn
  }
}