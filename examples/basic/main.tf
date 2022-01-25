module "basic_recovery_controller_example" {
  source = "../.."

  name                    = var.name
  create_recovery_cluster = var.create_recovery_cluster
  hosted_zone             = var.hosted_zone

  cells_definition = {
    us-east-1 = {
      autoscaling          = module.sample_app.asg_primary.arn
      elasticloadbalancing = module.sample_app.alb_primary.arn
      dynamodb             = module.sample_app.dynamodb.arn
    }
    us-west-2 = {
      autoscaling          = module.sample_app.asg_alternative.arn
      elasticloadbalancing = module.sample_app.alb_alternative.arn
      dynamodb             = replace(module.sample_app.dynamodb.arn, "us-east-1", "us-west-2")
    }
  }
}

# sample app is for demonstratino purposes only and is not safe for production workloads
module "sample_app" {
  source      = "../../modules/sample_app"
  allowed_ips = var.allowed_ips
}

# Regions must be hard coded for example since theyre defined explicitly in `cells_definition`
provider "aws" {
  region = "us-east-1"
}
