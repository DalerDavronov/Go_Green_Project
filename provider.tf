terraform {
  cloud {
    organization = "Ziyotek_Terraform_Class_Summer_Cloud"

    workspaces {
      name = "Go_Green_project"
    }
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.31.0"
    }
  }
}

provider "aws" {
  region = "us-west-1"
}