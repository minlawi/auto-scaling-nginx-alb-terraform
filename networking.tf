# # # VPC Configuration
resource "aws_vpc" "nginx_vpc" {
  count                = var.create_vpc ? 1 : 0
  cidr_block           = var.cidr_block[0]
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "Nginx-VPC"
  }
}

# # Subnets (Public)
resource "aws_subnet" "public_subnet" {
  count                   = var.create_vpc ? length(data.aws_availability_zones.available.names) : 0
  vpc_id                  = aws_vpc.nginx_vpc[0].id
  cidr_block              = cidrsubnet(aws_vpc.nginx_vpc[0].cidr_block, 4, count.index)
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "Public-Subnet-${count.index}"
  }
}

# # Subnets (Private)
resource "aws_subnet" "private_subnet" {
  count                   = var.create_vpc ? length(data.aws_availability_zones.available.names) : 0
  vpc_id                  = aws_vpc.nginx_vpc[0].id
  cidr_block              = cidrsubnet(aws_vpc.nginx_vpc[0].cidr_block, 4, count.index + length(data.aws_availability_zones.available.names))
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "Private-Subnet-${count.index}"
  }
}

# # Internet Gateway
resource "aws_internet_gateway" "igw" {
  count  = var.create_vpc ? 1 : 0
  vpc_id = aws_vpc.nginx_vpc[0].id

  tags = {
    Name = "IGW"
  }
}

# # Route Table for Public Subnet
resource "aws_route_table" "public_rt" {
  count  = var.create_vpc ? 1 : 0
  vpc_id = aws_vpc.nginx_vpc[0].id
  tags = {
    Name = "Public-Route-Table"
  }
}

# # Add default route to Public Route Table
resource "aws_route" "default_route_public_rt" {
  count                  = var.create_vpc ? 1 : 0
  route_table_id         = aws_route_table.public_rt[0].id
  destination_cidr_block = local.anywhere
  gateway_id             = aws_internet_gateway.igw[0].id
}

# # Associate Public Route Table with Public Subnet
resource "aws_route_table_association" "public_association" {
  count          = var.create_vpc ? length(aws_subnet.public_subnet) : 0
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt[0].id
}

# # Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  count  = var.create_vpc ? 1 : 0
  domain = "vpc"
}

# # NAT Gateway in Public Subnet
resource "aws_nat_gateway" "nat_gw" {
  count         = var.create_vpc ? 1 : 0
  allocation_id = aws_eip.nat_eip[0].id
  subnet_id     = aws_subnet.public_subnet[0].id
  tags = {
    Name = "Public-NAT-Gateway"
  }
}

# # Create Route Table to Private Subnet
resource "aws_route_table" "private_rt" {
  count  = var.create_vpc ? 1 : 0
  vpc_id = aws_vpc.nginx_vpc[0].id
  tags = {
    Name = "Private-Route-Table"
  }
}

# # Add default route to Private Route Table
resource "aws_route" "default_route_private_rt" {
  count                  = var.create_vpc ? 1 : 0
  route_table_id         = aws_route_table.private_rt[0].id
  destination_cidr_block = local.anywhere
  nat_gateway_id         = aws_nat_gateway.nat_gw[0].id
}

# # Associate Private Route Table with Private Subnet
resource "aws_route_table_association" "private_association" {
  count          = var.create_vpc ? length(aws_subnet.private_subnet) : 0
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_rt[0].id
}