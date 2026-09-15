terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92"
    }
    # grava a policy do bucket de imagens em arquivo (armazenamento.tf)
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }

  # terraform_data, usado no modo Learner Lab, existe desde a 1.4
  required_version = ">= 1.4"
}

provider "aws" {
  region = "us-east-1"
}