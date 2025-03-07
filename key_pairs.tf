# resource "tls_private_key" "key_pair" {
#   count     = var.create_bastion ? 1 : 0
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# resource "local_file" "private_key" {
#   count           = var.create_bastion ? 1 : 0
#   content         = tls_private_key.key_pair[0].private_key_pem
#   filename        = "${path.module}/generated/bastion_sg.pem"
#   file_permission = 400
# }

# resource "aws_key_pair" "public_key" {
#   count      = var.create_bastion ? 1 : 0
#   key_name   = "bastion_key_pair"
#   public_key = tls_private_key.key_pair[0].public_key_openssh
# }