locals {
  tags = merge(var.additional_tags, {
    Name    = var.name,
    Module  = "terraform-aws-tailscale",
    Purpose = "tailscale"
  })
}

variable "vpc_id" {
  description = "VPC ID to deploy tailscale cluster"
  type        = string
}

variable "name" {
  description = "name of resources"
  type        = string
}

variable "key_pair_name" {
  type        = string
  description = "Name of AWS key pair for SSH into tailscale instances"
  default     = null
}

variable "public_subnet_ids" {
  description = "List of public subnet ids for tailscale"
  type        = list(string)
}

# variable "allow_cidr_blocks_to_workers" {
#   description = "IP addresses to allow connection to tailscale workers"
#   type        = list(string)
# }

variable "additional_tags" {
  description = "List of tags for tailscale resources"
  default     = {}
  type        = map(string)
}

variable "tailscale_authkey" {
  description = "TailScale Auth Key"
  type        = string
}
