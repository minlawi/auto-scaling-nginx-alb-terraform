output "alb_dns_name" {
  value = var.create_vpc ? aws_alb.blue_green_lb[0].dns_name : null
}

output "bastion_public_ip" {
  value = var.create_bastion ? aws_instance.bastion_instance[0].public_ip : null
}

output "blue_instance_private_ip" {
  value = var.create_vpc ? data.aws_instances.blue_instance[0].private_ip : null
}

output "green_instance_private_ip" {
  value = var.create_vpc ? data.aws_instances.green_instance[0].private_ip : null
}