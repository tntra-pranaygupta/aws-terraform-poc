# providers.tf
# Declares which providers Terraform should download
# A "provider" is a plugin that knows how to talk to a specific API (AWS, GCP, etc.)

terraform {
  required_version = ">= 1.8.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Any 5.x version, not 6.x
    }
  }
}

provider "aws" {
  region = var.aws_region

  # Tags applied to ALL resources automatically (great for cost tracking)
  default_tags {
    tags = {
      Project     = "terraform-poc"
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  }
}