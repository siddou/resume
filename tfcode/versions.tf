terraform {
  required_version = ">= 0.13.1"
  backend "remote" {
    organization = "Siddou"

    workspaces {
      name = "resume"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 4.0"
    }
  }
}
provider "aws" {
  region     = var.AWS_REGION
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
  default_tags {
    tags = {
      Owner = var.OWNER
    }
  }
}

provider "aws" {
  region     = "us-east-1"
  alias      = "us-east-1"
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
  default_tags {
    tags = {
      Owner = var.OWNER
    }
  }
}
provider "github" {
  token = var.GITHUB_TOKEN
}

