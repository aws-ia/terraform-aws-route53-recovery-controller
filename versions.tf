terraform {
  experiments = [module_variable_optional_attrs]
  required_providers {
    awscc = {
      source  = "hashicorp/awscc"
      version = "~> 0.9"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.68"
    }
  }
}

provider "awscc" {
  user_agent = [{
    product_name    = "terraform-awscc-route53recoverycontroller"
    product_version = "0.0.1"
    comment         = "V1/AWS-D69B4015/440615363"
  }]
}
