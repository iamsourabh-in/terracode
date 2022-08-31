terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
    time = {
      source = "hashicorp/time"
      version = "0.8.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.3.2"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.13.1"
    }
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.20.0"
    }
  }
}


provider "aws" {
  profile = "dev_admin_developer_cache"
  region  = "ap-south-1"
}

provider "time" {

}

provider "kubernetes" {
  config_path    = "~/.kube/config"
}

provider "azurerm" {
  # Configuration options
}