output "alb_dns_name" {
  value = var.create_vpc ? aws_alb.app_lb[0].dns_name : null
}