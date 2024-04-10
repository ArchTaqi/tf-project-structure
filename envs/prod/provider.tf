# Terraform setup
terraform {
  required_version = ">= 1.2.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3"
    }
  }
}

# Provider
provider "aws" {
  region  = var.region
  profile = var.profile
}
