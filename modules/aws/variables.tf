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

variable "additional_tags" {
  description = "List of tags for tailscale resources"
  default     = {}
  type        = map(string)
}

variable "tailscale_authkey" {
  description = "TailScale Auth Key"
  type        = string
}

variable "hostname" {
  description = "TailScale Hostname Machine"
  type        = string
  default     = "aws-t4g-micro"
}

variable "enable_tailscale_ssh" {
  description = "Enable Tailscale ssh on the node"
  type        = bool
  default     = true

}

variable "advertise_routes" {
  description = "routes to advertise to other nodes (comma-separated, e.g. '10.0.0.0/8,192.168.0.0/24') or empty string to not advertise routes"
  type        = string
}

variable "instance_type" {
  description = "Instance type to use for the instance."
  default     = "t4g.micro"
  type        = string
}

variable "spot_price" {
  description = "The maximum price to request on the spot market."
  type        = string
}
