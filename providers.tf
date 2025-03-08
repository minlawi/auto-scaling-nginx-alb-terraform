terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.89.0"
    }
  }
  # backend "s3" {
  #   bucket       = "lawi-bucket"
  #   key          = "terraform.tfstate"
  #   region       = "us-east-1"
  #   encrypt      = true
  #   profile      = "master-programmatic-admin"
  #   use_lockfile = true
  # }
}

provider "aws" {
  # Configuration options
  profile = var.profile
}

locals {
  anywhere        = "0.0.0.0/0"
  http_port       = 80
  http_protocol   = "HTTP"
  tcp_protocol    = "tcp"
  all             = -1
  ssh             = 22
  server_t2_micro = "t2.micro"
  icmp_protocol   = "icmp"
}