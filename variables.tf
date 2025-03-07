variable "profile" {
  description = "AWS profile"
  type        = string
  default     = ""
}

variable "create_vpc" {
  description = "Create a new VPC"
  type        = bool
  default     = false
}

variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = list(string)
  default     = []
}

variable "create_bastion" {
  description = "Create a bastion host"
  type        = bool
  default     = false
}