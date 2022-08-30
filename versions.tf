terraform {
  required_version = "> 1"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4"
    }
  }
}

provider "aws" {
  region = "us-west-2"
  # default_tags {
  #   tags = var.default_tags
  # }
}
