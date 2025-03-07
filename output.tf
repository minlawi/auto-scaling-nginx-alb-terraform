output "alb_dns_name" {
  value = var.create_vpc ? aws_alb.app_lb[0].dns_name : null
}

output "bastion_public_ip" {
  value = var.create_bastion ? aws_instance.bastion_instance[0].public_ip : null
}

output "nginx_instances" {
  value = data.aws_instances.nginx.private_ips
}