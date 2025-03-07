# This aws_instance resource is not needed as we are using ASG
# resource "aws_instance" "nginx_instances" {
#   count                       = var.create_vpc ? length(data.aws_availability_zones.available.names) : 0
#   ami                         = data.aws_ami.ubuntu.id
#   instance_type               = local.server_t2_micro
#   subnet_id                   = aws_subnet.private_subnet[count.index].id
#   availability_zone           = data.aws_availability_zones.available.names[count.index]
#   associate_public_ip_address = false
#   security_groups             = [aws_security_group.nginx_sg[0].id]
#   user_data                   = file("${path.root}/scripts/nginx-install.sh")
#   user_data_replace_on_change = true
#   tags = {
#     Name = "Nginx-Server-${count.index}"
#   }
#   lifecycle {
#     ignore_changes = [
#       security_groups
#     ]
#   }
# }

# resource "aws_instance" "bastion_instance" {
#   count                       = var.create_bastion ? 1 : 0
#   ami                         = data.aws_ami.ubuntu.id
#   instance_type               = local.server_t2_micro
#   subnet_id                   = aws_subnet.public_subnet[0].id
#   availability_zone           = data.aws_availability_zones.available.names[0]
#   key_name                    = var.create_bastion ? aws_key_pair.public_key[0].key_name : null
#   associate_public_ip_address = true
#   security_groups             = [aws_security_group.bastion_sg[0].id]
#   user_data_replace_on_change = true
#   tags = {
#     Name = "Bastion-Jumphost"
#   }
#   lifecycle {
#     ignore_changes = [
#       security_groups
#     ]
#   }
# }