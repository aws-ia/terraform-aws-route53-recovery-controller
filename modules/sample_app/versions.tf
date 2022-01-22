terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.68"
    }
  }
}

provider "aws" {
  alias  = "alternative"
  region = "us-west-2"
}
