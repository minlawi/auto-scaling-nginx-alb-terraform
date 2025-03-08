terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.89.0"
    }
  }
  backend "s3" {
    bucket       = "lawi-bucket"
    encrypt      = true
    key          = "backend/terraform.tfstate"
    region       = "ap-southeast-1"
    profile      = var.profile
    use_lockfile = true
  }
}

provider "aws" {
  # Configuration options
  profile = var.profile
}