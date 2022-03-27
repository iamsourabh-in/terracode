terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}


provider "aws" {
  profile = "aws_dev_cache_developer"
  region  = "us-east-1"
}
