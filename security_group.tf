# Create a security group for the Bastion host
resource "aws_security_group" "bastion_sg" {
  count  = var.create_vpc ? 1 : 0
  vpc_id = aws_vpc.nginx_vpc[0].id
  name   = "bastion_sg"
}

# Allow SSH ingress traffic from anywhere
resource "aws_security_group_rule" "bastion_allow_ingress_ssh" {
  count             = var.create_vpc ? 1 : 0
  security_group_id = aws_security_group.bastion_sg[0].id
  type              = "ingress"
  from_port         = local.ssh
  to_port           = local.ssh
  protocol          = local.tcp_protocol
  cidr_blocks       = [local.anywhere]
}

# Allow all egress traffic
resource "aws_security_group_rule" "bastion_allow_all_egress_traffic" {
  count             = var.create_vpc ? 1 : 0
  security_group_id = aws_security_group.bastion_sg[0].id
  type              = "egress"
  from_port         = local.all
  to_port           = local.all
  protocol          = local.all
  cidr_blocks       = [local.anywhere]
}


# Create a security group for the ALB
resource "aws_security_group" "alb_sg" {
  count  = var.create_vpc ? 1 : 0
  vpc_id = aws_vpc.nginx_vpc[0].id
  name   = "alb_sg"
}

# Allow HTTP ingress traffic from anywhere
resource "aws_security_group_rule" "alb_allow_ingress_http" {
  count             = var.create_vpc ? 1 : 0
  security_group_id = aws_security_group.alb_sg[0].id
  type              = "ingress"
  from_port         = local.http_port
  to_port           = local.http_port
  protocol          = local.tcp_protocol
  cidr_blocks       = [local.anywhere]
}

# Allow all egress traffic
resource "aws_security_group_rule" "alb_allow_all_egress_traffic" {
  count             = var.create_vpc ? 1 : 0
  security_group_id = aws_security_group.alb_sg[0].id
  type              = "egress"
  from_port         = local.all
  to_port           = local.all
  protocol          = local.all
  cidr_blocks       = [local.anywhere]
}


# Create a security group for the web servers
resource "aws_security_group" "nginx_sg" {
  count  = var.create_vpc ? 1 : 0
  vpc_id = aws_vpc.nginx_vpc[0].id
  name   = "nginx_sg"
}

# Allow HTTP ingress traffic from the ALB
resource "aws_security_group_rule" "nginx_allow_ingress_http_from_alb" {
  count                    = var.create_vpc ? 1 : 0
  security_group_id        = aws_security_group.nginx_sg[0].id
  type                     = "ingress"
  from_port                = local.http_port
  to_port                  = local.http_port
  protocol                 = local.tcp_protocol
  source_security_group_id = aws_security_group.alb_sg[0].id
}

# Allow SSH ingress traffic from the Bastion host
resource "aws_security_group_rule" "nginx_allow_ingress_ssh_from_bastion" {
  count                    = var.create_vpc ? 1 : 0
  security_group_id        = aws_security_group.nginx_sg[0].id
  type                     = "ingress"
  from_port                = local.ssh
  to_port                  = local.ssh
  protocol                 = local.tcp_protocol
  source_security_group_id = aws_security_group.bastion_sg[0].id
}

# Allow ICMP ingress traffic from Bastion host
resource "aws_security_group_rule" "nginx_allow_ingress_icmp_from_bastion" {
  count                    = var.create_vpc ? 1 : 0
  security_group_id        = aws_security_group.nginx_sg[0].id
  type                     = "ingress"
  from_port                = local.all
  to_port                  = local.all
  protocol                 = local.icmp_protocol
  source_security_group_id = aws_security_group.bastion_sg[0].id
}

# Allow all egress traffic
resource "aws_security_group_rule" "nginx_allow_all_egress_traffic" {
  count             = var.create_vpc ? 1 : 0
  security_group_id = aws_security_group.nginx_sg[0].id
  type              = "egress"
  from_port         = local.all
  to_port           = local.all
  protocol          = local.all
  cidr_blocks       = [local.anywhere]
}