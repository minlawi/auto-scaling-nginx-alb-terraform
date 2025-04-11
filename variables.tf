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

variable "active_environment" {
  description = "Choose the active environment for the load balancer. Options are 'blue' or 'green'."
  type        = string
  validation {
    condition     = contains(["blue", "green"], var.active_environment)
    error_message = "The active_environment variable must be either 'blue' or 'green'."
  }
}