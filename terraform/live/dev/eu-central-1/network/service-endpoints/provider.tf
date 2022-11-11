################################################################################
# Set required providers and version
################################################################################

terraform {
  backend "s3" {
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=3.68.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = ">=2.2.0"
    }
  }
  required_version = ">=1.1.2"
}

provider "aws" {
  region = var.aws_region
}
